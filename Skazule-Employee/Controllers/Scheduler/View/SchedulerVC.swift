//
//  SchedulerVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 1/31/23.
//

import UIKit
import CoreMedia

class SchedulerVC: UIViewController {
    
    
    //MARK: IBOutlets
    @IBOutlet weak var customNavigationBarDrawer: CustomNavigationBarForDrawer!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    
    //MARK: VAriables
    var viewModel:SchedulerViewModel?
    
    let datePicker = UIDatePicker()
    var selectedDateByCalenderPicker = Date()
    
    var isSelected = 0
    var isSelectedDateArr = [Bool]()
    var isSelectedDate = false
    var currentWeekArr = [CurrentWeekStruct]()
    var schedulerRsponse = SchedulerResponse()
    var schedulerFiletedData = [OpenSchedule]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        
        configureNavigationBar()
        configureDatePicker()
        configureCollectionView()
        configureTableView()
        
        self.changeCurrentWeek(selectedDateStr: currentDateWithFormater2())
        self.dateTextField.text = currentDateShowInCalender(dateStr: currentDateWithFormater2())
        dateTextField.delegate = self
//        self.integrateSchedulerApi(selectedDate: currentDateWithFormater2())
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.changeCurrentWeek(selectedDateStr: currentDateWithFormater2())
        //        self.dateTextField.text = currentDateShowInCalender(dateStr: currentDateWithFormater2())
               self.integrateSchedulerApi(selectedDate: currentDateWithFormater2())
    }
    //MARK: Private functions
    private func setUp(){
        self.recheckVM()
    }
    private func configureNavigationBar(){
        self.customNavigationBarDrawer.titleLabel.text = "Scheduler"
        customNavigationBarDrawer.rightBtn.isHidden = true
        customNavigationBarDrawer.rightBtn.addTarget(self, action: #selector(didTapNotificationButton), for: .touchUpInside)
        customNavigationBarDrawer.notificationView.isHidden = true
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
        tableView.register(UINib(nibName: "SchedulerTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SchedulerTableViewCell")
    }
    //MARK: Notification button taped
    @objc func didTapNotificationButton (_ sender:UIButton) {
        print("Notification Button is Taped")
        let vc = NotificationsVC()
        vc.notificationsListRespose = customNavigationBarDrawer.notificationsListRespose
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Handle date selection from Date Picker
    @objc func handleDateSelection()
    {
        let selectedDate = dateWithFormater2(selectedDate: datePicker.date)
        self.dateTextField.text = dateWithFormater3(selectedDate: datePicker.date)
        print(selectedDate)
        self.selectedDateByCalenderPicker = datePicker.date
        print(self.selectedDateByCalenderPicker)
        self.changeCurrentWeek(selectedDateStr: selectedDate)
        self.integrateSchedulerApi(selectedDate: selectedDate)
        
    }
    func changeCurrentWeek(selectedDateStr:String)
    {
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

extension SchedulerVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = SchedulerViewModel()
        }
    }
}
//MARK: Schduler Api Integration

extension SchedulerVC{
    private func integrateSchedulerApi(selectedDate:String){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_SCHEDULER_API
        let employeeId = String(getEmployeeId())
        let companyId = String(getCompanyId())
        let param:[String:String] = [ "employee_id":employeeId,"filter":"2","company_id":companyId,"date_filter":selectedDate]
        
        //company_id:217
        //employee_id:176
        //filter:4
        //date_filter:2023-03-15 //optional
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModel?.requestSchedulerApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(SchedulerResponse.self, from: jsonData!)
                    print(responseData)
                    self?.schedulerRsponse = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processSchedulerResponse(receivedData: self!.schedulerRsponse,selectedDate:selectedDate)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    func processSchedulerResponse(receivedData:SchedulerResponse,selectedDate:String){
        
        if receivedData.status == 1{
            let message = receivedData.message ?? ""
            
            self.schedulerFiletedData.removeAll()
            
            for item in receivedData.data?.openSchedules ?? [] {
                
                let checkInStr = item.checkIn ?? ""
                let dateStr = item.date ?? ""
                let dateWithTimeStr = dateStr + " " + checkInStr
                print(dateWithTimeStr)
                guard let dateStrLocal = gmtToLocalDate(dateStr: dateWithTimeStr) else{return}
                print(dateStr)
                print("Local Date : ",dateStrLocal)
                print("Selected Date : ",selectedDate)
                
                if selectedDate == dateStrLocal{
                    self.schedulerFiletedData.append(item)
                }
            }
            
            if self.schedulerFiletedData.count != 0{
                
                self.noDataView.isHidden = true
                self.tableView.reloadData()
            }else{
                self.noDataView.isHidden = false
            }
            //           print( receivedData.data?.openSchedules?.count)
            //            if receivedData.data?.openSchedules?.count != 0{
            //                self.tableView.reloadData()
            //            }
        }else{
            let message = receivedData.message
            //           UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}
//MARK: Collection View Delegate and Data Source
extension SchedulerVC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
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
        self.integrateSchedulerApi(selectedDate: dateStr)
    }
}
//MARK: Table View Delegate and Data Source
extension SchedulerVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.schedulerFiletedData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SchedulerTableViewCell", for: indexPath) as? SchedulerTableViewCell else{return UITableViewCell()}
        
        let info = self.schedulerFiletedData[indexPath.row]
        
        print(info)
        
        cell.openScheduleData = info
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80//UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ViewOpenShiftVC()
        let info = self.schedulerFiletedData[indexPath.row]
        
        print(info)
        
        let status = self.schedulerRsponse.status
        vc.info = info
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: Text Field Delegates
extension SchedulerVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}
