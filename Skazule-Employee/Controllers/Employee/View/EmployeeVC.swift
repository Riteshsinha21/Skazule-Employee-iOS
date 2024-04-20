//
//  EmployeeVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 1/31/23.
//

import UIKit

class EmployeeVC: UIViewController {
    
    
    //MARK: IBOutlets
    @IBOutlet weak var customNavigationBarDrawer: CustomNavigationBarForDrawer!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var NoDataView: UIView!
    
    
    
 //MARK: Variables
    
    let datePicker = UIDatePicker()
    var viewModel:EmployeeViewModel?
    var employeeResponse = EmployeeResponse()

//MARK: View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
        configureNavigationBar()
        configureDatePicker()
        configureTableView()
        configureTextFields()
//        integrateCheckInCheckOutListApi()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        fromDateTextField.text = ""
//        toDateTextField.text = ""
        integrateCheckInCheckOutListApi()
    }
    //MARK: Private functions
    private func setUp(){
        self.recheckVM()
    }
    private func configureNavigationBar(){
        self.customNavigationBarDrawer.titleLabel.text = "Employee"
        customNavigationBarDrawer.rightBtn.isHidden = true
        customNavigationBarDrawer.rightBtn.addTarget(self, action: #selector(didTapNotificationButton), for: .touchUpInside)
        customNavigationBarDrawer.notificationView.isHidden = true
    }
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "EmployeeTableViewCell")
    }
    private func configureTextFields(){
        fromDateTextField.delegate = self
        toDateTextField.delegate = self
       
    }
    private func configureDatePicker(){

        self.fromDateTextField.inputView = datePicker
        self.toDateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.date = Date()
        datePicker.locale = .current
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .inline //.compact
        } else {
            // Fallback on earlier versions
        }

        datePicker.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)

    }
    //MARK: Handle date selection from Date Picker
    @objc func handleDateSelection()
    {
        
        let selectedDate = dateWithFormater2(selectedDate: datePicker.date)
        if fromDateTextField.isFirstResponder{
            self.fromDateTextField.text = dateWithFormater2(selectedDate: datePicker.date)
        }
        if toDateTextField.isFirstResponder{
            self.toDateTextField.text = dateWithFormater2(selectedDate: datePicker.date)
        }
     
        print(selectedDate)
        self.view.endEditing(true)

    }
    //MARK: Notification button taped
    @objc func didTapNotificationButton (_ sender:UIButton) {
        print("Notification Button is Taped")
        let vc = NotificationsVC()
        vc.notificationsListRespose = customNavigationBarDrawer.notificationsListRespose
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: SUBMIT button clicked
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        integrateCheckInCheckOutListApi(fromDate: fromDateTextField.text, toDate: toDateTextField.text)
    }
}

//MARK: Table View Delegate and Data Source
extension EmployeeVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.employeeResponse.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as? EmployeeTableViewCell else{return UITableViewCell()}
        
        let info = self.employeeResponse.data?[indexPath.row]
//        let info = self.schedulerFiletedData[indexPath.row]
        cell.shiftCheckIn = self.employeeResponse.data?[indexPath.row].shiftCheckIn
        cell.shiftCheckOut = self.employeeResponse.data?[indexPath.row].shiftCheckOut
        cell.employeeData = info
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = ViewOpenShiftVC()
//        let info = self.schedulerRsponse.data?.openSchedules?[indexPath.row]
//        let status = self.schedulerRsponse.status
////        if status == Int(KOne){
////          print("Schedule request can't be submitted as you have already...!")
////        }else{
//            vc.info = info
//            self.navigationController?.pushViewController(vc, animated: true)
// //       }
//    }
}
//MARK: Initialize view model
extension EmployeeVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = EmployeeViewModel()
        }
    }
}

//MARK: Integrate Employe Check In Check Out List API
extension EmployeeVC{
    private func integrateCheckInCheckOutListApi(fromDate:String? = nil,toDate:String? = nil){
        
        print(fromDate,toDate)

        let fullUrl = BASE_URL + PROJECT_URL.GET_CHECKIN_CHECKOUT_LIST_API
        let employeeId = String(getEmployeeId())
        let companyId = String(getCompanyId())
        var param = [String:String]()
        
        if let fromDate = fromDate{
            if let toDate = toDate {
                param = ["employee_id":employeeId,"company_id":companyId,"from_date":fromDate,"to_date":toDate,"page": "0","limit": "10"]
            }
        }else{
            param = [ "employee_id":employeeId,"company_id":companyId,"page": "0","limit": "10"]
        }
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModel?.requestCheckInCheckOutListApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
               
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(EmployeeResponse.self, from: jsonData!)
                    print(responseData)
                    self?.employeeResponse = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }

                strongSelf.processEmployeeResponse(receivedData: self!.employeeResponse)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    func processEmployeeResponse(receivedData:EmployeeResponse){
        if receivedData.status == 1{
            DispatchQueue.main.async {
                self.NoDataView.isHidden = true
                self.tableView.reloadData()
            }
        }else{
            let message = receivedData.message ?? ""
            NoDataView.isHidden = false
        //    UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}
//MARK: Text Field Delegate
extension EmployeeVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}
