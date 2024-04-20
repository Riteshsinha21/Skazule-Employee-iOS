//
//  MySheduleVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/17/23.
//

import UIKit
import CoreMedia

class MySheduleVC: UIViewController{
    
    //MARK: IBOutlets
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: VAriables
    var viewModel:MySheduleViewModeling?
    
    let datePicker = UIDatePicker()
    var selectedDateByCalenderPicker = Date()
    
    var isSelected = 0
    var isSelectedDateArr = [Bool]()
    var isSelectedDate = false
    var currentWeekArr = [CurrentWeekStruct]()
    var mySheduleRsponse = MySheduleResponse()
    var myScheduleFilteredData = [MySheduleData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        configureNavigationBar()
        configureDatePicker()
        configureCollectionView()
        configureTableView()
//        self.integrateGetMySheduleApi(selectedDate: currentDateWithFormater2())
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.integrateGetMySheduleApi(selectedDate: currentDateWithFormater2())
        self.changeCurrentWeek(selectedDateStr: currentDateWithFormater2())
        self.dateTextField.text = currentDateShowInCalender(dateStr: currentDateWithFormater2())
        dateTextField.delegate = self
    }
    //MARK: Private functions
    private func setUp(){
        self.recheckVM()
    }
    private func configureNavigationBar(){
        self.customNavigationBar.titleLabel.text = "My Schedule"
        customNavigationBar.customRightBarButton.isHidden = true
        customNavigationBar.customRightBarButton.addTarget(self, action: #selector(didTapNotificationButton), for: .touchUpInside)
    }
    private func configureDatePicker(){
        
        self.dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.locale = .current
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .inline //.compact
        } else {
            // Fallback on earlier versions
        }
        
        datePicker.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
        
    }
    private func configureCollectionView(){
        
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        calenderCollectionView.register(UINib(nibName: "MyScheduleCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MyScheduleCollectionViewCell")
    }
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyScheduleTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MyScheduleTableViewCell")
    }
    //MARK: Notification button taped
    @objc func didTapNotificationButton (_ sender:UIButton) {
        print("Notification Button is Taped")
        let vc = NotificationsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Handle date selection from Date Picker
    @objc func handleDateSelection()
    {
        //        let dateFormetter = DateFormatter()
        //        dateFormetter.dateStyle = .medium
        //        dateFormetter.timeStyle = .none
        //        self.dateTextField.text = dateFormetter.string(from: datePicker.date)
        //        dateFormetter.dateFormat = "yyyy-MM-dd"
        //        let selectedDate = dateFormetter.string(from: datePicker.date)
        let selectedDate = dateWithFormater2(selectedDate: datePicker.date)
        self.dateTextField.text = dateWithFormater3(selectedDate: datePicker.date)
        print(selectedDate)
        self.selectedDateByCalenderPicker = datePicker.date
        print(self.selectedDateByCalenderPicker)
        self.changeCurrentWeek(selectedDateStr: selectedDate)
        self.integrateGetMySheduleApi(selectedDate: selectedDate)
        tableView.reloadData()
    }
    func changeCurrentWeek(selectedDateStr:String){
        let weekArr = self.selectedDateByCalenderPicker.daysOfWeek(using: .iso8601).map(\.ddMMyyyy)
        self.currentWeekArr.removeAll()
        let selectedDateArr = selectedDateStr.split(separator: "-")
        self.isSelectedDateArr.removeAll()
        for i in 0..<weekArr.count{
            let weekStr = weekArr[i]
            let dateArr = weekStr.split(separator: ".")
            self.currentWeekArr.append(CurrentWeekStruct.init(date: String(dateArr[0]), month: String(dateArr[1]), year: String(dateArr[2]), day: dayNameArr[i]))
            
            dateArr[0] == selectedDateArr[2] ? self.isSelectedDateArr.append(true) :self.isSelectedDateArr.append(false)
            
        }
        print(self.isSelectedDateArr)
        print(currentWeekArr)
        self.calenderCollectionView.reloadData()
        self.selectedDateLabel.text = selectedDate(selectDate: self.selectedDateByCalenderPicker)
    }
}

extension MySheduleVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = MySheduleViewModel()
        }
    }
}
extension MySheduleVC{
    private func integrateGetMySheduleApi(selectedDate:String){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_MYSHEDULE_API
        let employeeId = String(getEmployeeId())
        let param:[String:String] = [ "employee_id":employeeId,"filter":"2","date_filter":selectedDate]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModel?.requestMySheduleApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(MySheduleResponse.self, from: jsonData!)
                    print(responseData)
                    self?.mySheduleRsponse = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processMySheduleResponse(receivedData: self!.mySheduleRsponse,selectedDate:selectedDate)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    //MARK: Process My Schedule Response
    
    func processMySheduleResponse(receivedData:MySheduleResponse,selectedDate:String){
        
        print(selectedDate)
        
        if receivedData.status == 1{
            let message = receivedData.message ?? ""
            
            self.myScheduleFilteredData.removeAll()
            
            for item in receivedData.data ?? [] {
                
                let checkInStr = item.checkIn ?? ""
                let dateStr = item.date ?? ""
                let dateWithTimeStr = dateStr + " " + checkInStr
                print(dateWithTimeStr)
                let dateStrLocal = gmtToLocalDate(dateStr: dateWithTimeStr)
                print(dateStr)
                
                if selectedDate == dateStrLocal{
                    self.myScheduleFilteredData.append(item)
                }
            }
            
            if self.myScheduleFilteredData.count != 0{
                
                self.noDataView.isHidden = true
                self.tableView.reloadData()
            }else{
                self.noDataView.isHidden = false
            }
        }else{
            let message = receivedData.message
  //          UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}
//MARK: Collection View Delegate and Data Source
extension MySheduleVC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentWeekArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyScheduleCollectionViewCell", for: indexPath) as? MyScheduleCollectionViewCell else{ return UICollectionViewCell()}
        //        cell.congigureCell()
        
        var info = self.currentWeekArr[indexPath.row]
        
        info.cellBackgroundColor = (self.isSelectedDateArr[indexPath.item] == true) ? .white  : .systemGray6
        cell.currentWeekData = info
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        let screenSize              = collectionView.frame.size //UIScreen.main.bounds
        let screenWidth             = screenSize.width
        let cellSquareSize: CGFloat = (screenWidth / 7.0) - 5
        return CGSize.init(width: cellSquareSize, height: 85)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(5), right: 0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 5
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? MyScheduleCollectionViewCell
        for i in 0..<self.isSelectedDateArr.count
        {
            if self.isSelectedDateArr[i] == true{
                self.isSelectedDateArr[i] = false
            }
        }
        print(self.isSelectedDateArr)
        self.isSelectedDate = self.isSelectedDateArr[indexPath.row]
        self.isSelectedDate = !self.isSelectedDate
        
        cell?.cellView.backgroundColor = (self.isSelectedDateArr[indexPath.row] == true) ? .white : .systemGray6
        
        self.isSelectedDateArr[indexPath.row] = self.isSelectedDate
        print(self.isSelectedDateArr)
        self.calenderCollectionView.reloadData()
        
        let dateStr = "\(self.currentWeekArr[indexPath.row].year)-\(self.currentWeekArr[indexPath.row].month)-\(self.currentWeekArr[indexPath.row].date)"
        print(dateStr)
        self.dateTextField.text = currentDateShowInCalender(dateStr: dateStr)
        self.selectedDateLabel.text = selectedDateByCurrentWeek(dateStr: dateStr)
        self.integrateGetMySheduleApi(selectedDate: dateStr)
    }
}
//MARK: Table View Delegate and Data Source
extension MySheduleVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return self.mySheduleRsponse.data?.count ?? 0
        return  self.myScheduleFilteredData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyScheduleTableViewCell", for: indexPath) as? MyScheduleTableViewCell else{return UITableViewCell()}
        
        //        let info = self.mySheduleRsponse.data?[indexPath.row]
        let info = self.myScheduleFilteredData[indexPath.row]
        
        cell.myscheduleData = info
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80//UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ConfirmMyScheduleVC()
        //        let info = self.mySheduleRsponse.data?[indexPath.row]
        let info = self.myScheduleFilteredData[indexPath.row]
        print(info)
        if info.status == Int(KOne){
            showAlert(title: "Message", message: KAllreadyConfirmSchedule,viewController: self, okButtonTapped: {
            })
        }else{
            vc.info = info
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
//MARK: Text Field Delegates
extension MySheduleVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}
