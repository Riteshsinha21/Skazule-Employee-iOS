//
//  MyScheduleNewVC.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 9/28/23.
//

import UIKit

class MyScheduleNewVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var customNavigationBarDrawer: CustomNavigationBarForDrawer!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var assignedButton: UIButton!
    
    
    //MARK: VAriables
    var viewModel:RequestedScheduleViewModel?
    
    let datePicker = UIDatePicker()
    var selectedDateByCalenderPicker = Date()
    
    var currentWeekArr = [CurrentWeekStruct]()
    var mySheduleRsponse = MySheduleResponse()
    var myScheduleFilteredData = [MySheduleData]()
    var finalData = [MySheduleData]()
    var isFrom = KRequestedSchedule
    // For pagination 1
    var currentPage = 0
    var pageTotal = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        configureNavigationBar()
        configureDatePicker()
        configureTableView()
        tableView.reloadData()
        noDataView.isHidden = true
        requestButton.backgroundColor = Color.appButtonBlueColor
        integrateAppliedSheduleApi(pageNo: currentPage)
    }
    
    
    //MARK: Private functions
    private func setUp(){
        self.recheckVM()
    }
    private func configureNavigationBar(){
        self.customNavigationBarDrawer.titleLabel.text = "My Schedule"
        customNavigationBarDrawer.rightBtn.isHidden = true
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
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyScheduleNewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MyScheduleNewTableViewCell")
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
        
        
        var currentPage = 0
        var pageTotal = 0
        let selectedDate = dateWithFormater2(selectedDate: datePicker.date)
        self.dateTextField.text = dateWithFormater3(selectedDate: datePicker.date)
        print(selectedDate)
        self.selectedDateByCalenderPicker = datePicker.date
        print(self.selectedDateByCalenderPicker)
        self.integrateAppliedSheduleApi(selectedDate: selectedDate,pageNo: currentPage)
    }
    //MARK: Requested Button Taped
    @IBAction func requestButtonTaped(_ sender: Any) {
        isFrom = KRequestedSchedule
        currentPage = 0
        pageTotal = 0
        requestButton.setTitleColor(.white, for: .normal)
        requestButton.backgroundColor = Color.appButtonBlueColor
        assignedButton.setTitleColor(Color.appButtonBlueColor, for: .normal)
        assignedButton.backgroundColor = UIColor.clear
        self.integrateAppliedSheduleApi(pageNo:currentPage)
    }
    
    //MARK: Assigned Button Taped
    @IBAction func assignedButtonTaped(_ sender: Any) {
        isFrom = KAssignedSchedule
        currentPage = 0
        pageTotal = 0
        requestButton.setTitleColor(Color.appButtonBlueColor, for: .normal)
        requestButton.backgroundColor = UIColor.clear
        assignedButton.setTitleColor(.white, for: .normal)
        assignedButton.backgroundColor = Color.appButtonBlueColor
        self.integrateAppliedSheduleApi(pageNo:currentPage)
    }
}
extension MyScheduleNewVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = RequestedScheduleViewModel()
        }
    }
}
//MARK: Table View Delegate and Data Source
extension MyScheduleNewVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  finalData.count//self.mySheduleRsponse.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyScheduleNewTableViewCell", for: indexPath) as? MyScheduleNewTableViewCell else{return UITableViewCell()}
        
        let info =  finalData[indexPath.row]
        
        cell.configureCell(info: info, index: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
    // For pagination 4
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        if indexPath.row == (self.finalData.count - 1) {
            print(pageTotal,currentPage)
            
            if (self.finalData.count < (pageTotal)) && (currentPage != -1) {
                currentPage = currentPage + 1
                self.integrateAppliedSheduleApi(pageNo:currentPage)
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AssignedScheduleDetailsVC()
        //        let info = self.mySheduleRsponse.data?[indexPath.row]
        let info =  finalData[indexPath.row]
        print(info)
/*        if info.type == Int(KTwo){
            if info.status == Int(KOne){
                showAlert(title: "Message", message: KAllreadyConfirmSchedule,viewController: self, okButtonTapped: {
                })
            }else{print("Shift will be confirm by Employeer")}
        }else if info.type == Int(KOne){
            if info.status == Int(KZero){
                
                let date = info.date ?? ""
                let checkIn = info.checkIn ?? ""
                let checkOut = info.checkOut ?? ""
                let dateString = date + " " + checkIn
                let convertedLocalDateStr = gmtToLocalDate(dateStr: dateString)
                let convertedLocalCheckInStr = gmtToLocal(dateStr: checkIn)
                let convertedLocalCheckOutStr = gmtToLocal(dateStr: checkOut)
                
                let currentDateStr  = Date().toString(dateFormat: "yyyy-MM-dd")
                let currentTimeStr  = Date().toString(dateFormat: "h:mm a")
                
                
                if (currentDateStr > convertedLocalDateStr ?? "\(currentDateStr)"){
                    // self.assignBtnBackView.isHidden = true
                }else if (currentDateStr == convertedLocalDateStr ?? "\(currentDateStr)") && (isTimeCompareFromCurrentTime(currentTimeStr: currentTimeStr, timeIn: convertedLocalCheckInStr ?? "\(currentTimeStr)") == false){
                    //  self.assignBtnBackView.isHidden = true
                }else{
                    //                      self.assignBtnBackView.isHidden = false
                    //      vc.info = info
                    vc.status = info.status ?? 0
                    vc.isFrom = isFrom
                    vc.scheduleId = info.scheduleID ?? 0
                    vc.id = info.id ?? 0
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                showAlert(title: "Message", message: KAllreadyConfirmSchedule,viewController: self, okButtonTapped: {
                })
            }
        } */
        
        
        vc.status = info.status ?? 0
        vc.isFrom = isFrom
        vc.scheduleId = info.scheduleID ?? 0
        vc.id = info.id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: Text Field Delegates
extension MyScheduleNewVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}
//MARK:
extension MyScheduleNewVC{
    private func integrateAppliedSheduleApi(selectedDate:String? = nil,pageNo:Int){
        var fullUrl = String()
        
        fullUrl = requestButton.backgroundColor == Color.appButtonBlueColor ? (BASE_URL + PROJECT_URL.GET_APPLIED_SCHEDULE_API) : (BASE_URL + PROJECT_URL.GET_ASSIGNED_SCHEDULE_API)
        
        //        let fullUrl = BASE_URL + PROJECT_URL.GET_APPLIED_SCHEDULE_API
        print(fullUrl)
        let employeeId = String(getEmployeeId())
        var param = [String:Any]()
        
        if let selectedDate = selectedDate{
            param = [ "employee_id":employeeId,"date_filter":selectedDate,"page": 0,"limit": "10"]
        }else{
            param = [ "employee_id":employeeId,"page": "\(pageNo)","limit": "10"]
        }
        
        //       let param:[String:String] = [ "employee_id":employeeId,"Page":"0","limit":"5"]
        
        // "employee_id:307
        //    page:0
        //    limit:5
        //    date_filter:2023-09-25  //optional"
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModel?.requestAppliedSheduleApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
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
                
                strongSelf.processMySheduleResponse(receivedData: self!.mySheduleRsponse)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    //MARK: Process My Schedule Response
    
    func processMySheduleResponse(receivedData:MySheduleResponse){
        
        if receivedData.status == 1{
            let message = receivedData.message ?? ""
            self.pageTotal = receivedData.totalRecordCount ?? 0
            
            guard let myScheduleData = receivedData.data else{return}
            
            if self.currentPage == 0{
                self.finalData.removeAll()
                self.finalData = myScheduleData
            }else{
                for item in myScheduleData{
                    self.finalData.append(item)
                }
            }
            DispatchQueue.main.async {
                if self.finalData.count != 0{
                    self.noDataView.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }else{
                    self.noDataView.isHidden = false
                }
            }
        }else{
            self.tableView.isHidden = true
            self.noDataView.isHidden = false
            let message = receivedData.message
            // UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}
