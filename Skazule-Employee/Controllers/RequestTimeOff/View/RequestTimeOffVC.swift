//
//  RequestTimeOffVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/11/23.
//

import UIKit
import DropDown

class RequestTimeOffVC: UIViewController {
    
    //MARK: IBOutlets

    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    
    
    //MARK: VAriables
    let dropDown = DropDown()
    var requestTimeOffPopUp:RequestTimeOffPopUp!
    var viewModel:RequestTimeOffViewModel?
    var leaveTypeViewModel:LeaveTypeViewModel?
    var leaveTypeResponse = LeaveTypeRespose()
    var dropDownData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        configureNavigationBar()
        integrateLeaveTypeApi()
    }
    func setUp(){
        self.recheckVM()
    }
    
    //MARK: Private Functions
    
    private func configureNavigationBar(){
        self.customNavigationBar.titleLabel.text = "Time Off Request"
        customNavigationBar.customRightBarButton.isHidden = true
        customNavigationBar.customRightBarButton.addTarget(self, action: #selector(didTapNotificationButton), for: .touchUpInside)
    }
    
    //MARK: Notification button taped
    @objc func didTapNotificationButton (_ sender:UIButton) {
        print("Notification Button is Taped")
        let vc = NotificationsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Request Time Off button Taped
    @IBAction func requestTimeOffButtonTaped(_ sender: UIButton) {
        
        self.requestTimeOffPopUp = RequestTimeOffPopUp(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
       
        requestTimeOffPopUp.timeOffTypeButton.setTitle(self.leaveTypeResponse.data?[0].name, for: .normal)
        requestTimeOffPopUp.leaveTypeId = self.leaveTypeResponse.data?[0].id ?? 0
        requestTimeOffPopUp.testStr = "***************???????????"
        
        self.requestTimeOffPopUp.timeOffTypeButton.addTarget(self, action: #selector(self.setUpDropDown), for: .touchUpInside)
        self.requestTimeOffPopUp.sendRequestButton.addTarget(self, action: #selector(self.sendRequestTaped), for: .touchUpInside)
        self.view.addSubview(self.requestTimeOffPopUp)
    }
    //MARK: Send Request Button Taped
    @objc func sendRequestTaped(_ sender: UIButton) {
        print("****")
        self.checkValidation()
    }
   
    // MARK: - Validate entries
    func checkValidation() {
        let employeeId = String(getEmployeeId())
        let companyId =  String(getCompanyId())
        
        if let alert = self.viewModel?.verifyFields(companyId: companyId, employeeId: employeeId, reason: requestTimeOffPopUp.reasonTextView.text, leaveType: requestTimeOffPopUp.leaveTypeId, startDate: requestTimeOffPopUp.startDateTextField.text, endDate: requestTimeOffPopUp.endDateTextField.text), !alert.isEmpty {
            showMessageAlert(message: alert)
        } else {
            self.ingegrateRequestTimeOffApi()
        }
    }
    //MARK: Set up Drop Down
    @objc func setUpDropDown(_ sender:UIButton){
        
        dropDownData.removeAll()
        for item in self.leaveTypeResponse.data!{
            dropDownData.append(item.name ?? "")
        }
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
        dropDown.anchorView = sender
        dropDown.dataSource = dropDownData
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index:Int,item:String) in
            print("Selected item: \(item) at index: \(index)")
            sender.setTitle("\(item)", for: .normal)
            requestTimeOffPopUp.leaveTypeId = index + 1
        }
    }
    //MARK: Pending Request Taped
    @IBAction func pentingRequestButtonTaped(_ sender: Any) {
        let vc = RequestTimeOffListVC()
        vc.status = KZero // For pending requests status 0 is send
        
        if let leaveTypeData = self.leaveTypeResponse.data{
        vc.leaveTypeData = leaveTypeData
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Approved Request Taped
    @IBAction func approvedRequestButtonTaped(_ sender: Any) {
        let vc = RequestTimeOffListVC()
        vc.status = KOne // For approved requests status 1 is send
        if let leaveTypeData = self.leaveTypeResponse.data{
        vc.leaveTypeData = leaveTypeData
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Denied Request Taped
    @IBAction func deniedRequestButtonTaped(_ sender: Any) {
        let vc = RequestTimeOffListVC()
        vc.status = KThree // For denied requests status 3 is send
        if let leaveTypeData = self.leaveTypeResponse.data{
        vc.leaveTypeData = leaveTypeData
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
extension RequestTimeOffVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.leaveTypeViewModel == nil {
            self.leaveTypeViewModel = LeaveTypeViewModel()
        }
        if self.viewModel == nil{
            self.viewModel = RequestTimeOffViewModel()
        }
    }
}
extension RequestTimeOffVC{
    
    private func integrateLeaveTypeApi(){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_LEAVE_TYPE
        let employeeId = String(getEmployeeId())
        let param:[String:String] = [:]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.leaveTypeViewModel?.requestLeaveTypeApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(LeaveTypeRespose.self, from: jsonData!)
                    print(responseData)
                    self?.leaveTypeResponse = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processLeaveTypeResponse(receivedData: self!.leaveTypeResponse)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    func processLeaveTypeResponse(receivedData:LeaveTypeRespose){
        //        let message = receivedData.message ?? ""
        
        if receivedData.status == 1{
            let message = receivedData.message ?? ""
            
            //            showAlert(title: "Message", message: message,viewController: self, okButtonTapped: {
            //                // Push OTP Screen
            //            })
        }else{
            let message = receivedData.message
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}

extension RequestTimeOffVC{
    private func ingegrateRequestTimeOffApi(){
            
            let fullUrl = BASE_URL + PROJECT_URL.REQUEST_TIME_OFF_API
            let employeeId = String(getEmployeeId())
            let companyId =  String(getCompanyId())
        let param:[String:Any] = ["company_id":companyId,"employee_id":employeeId,"reason":requestTimeOffPopUp.reasonTextView.text!,  "leave_type":"\(requestTimeOffPopUp.leaveTypeId)","start_date":String(requestTimeOffPopUp.startDateTextField.text!),"end_date":String(requestTimeOffPopUp.endDateTextField.text!)]
        
            
            print(param)
            if Reachability.isConnectedToNetwork() {
                // showProgressOnView(appDelegateInstance.window!)
                showProgressOnView(self.view)
                self.viewModel?.requestTimeOffApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                    print(receivedData)
                    hideAllProgressOnView(self!.view)
                    var requestTimeOffResponse = RequestTimeOffResponse()
                    do{
                        let jsonData = self?.getDataFrom(JSON: receivedData)
                        print(String(data: jsonData!, encoding: .utf8)!)
                        let responseData = try JSONDecoder().decode(RequestTimeOffResponse.self, from: jsonData!)
                        print(responseData)
                        requestTimeOffResponse = responseData
                    }catch let error{
                        print(error.localizedDescription)
                    }
                    guard let strongSelf = self else { return }

                    strongSelf.processRequestTimeOffResponse(receivedData: requestTimeOffResponse)
                })
            }else{
                showLostInternetConnectivityAlert()
            }
        }
    func processRequestTimeOffResponse(receivedData:RequestTimeOffResponse){
        
        if receivedData.status == 1{
            let message = receivedData.message ?? ""
            
                        showAlert(title: "Message", message: message,viewController: self, okButtonTapped: {
                            //Remove Pop Up
                            self.removePopUpScreen()
                        })
        }else{
            let message = receivedData.message
 //           let message = receivedData.error?.reason?[0]
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
//MARK: Remove Pop Up Screen
    func removePopUpScreen(){
        self.requestTimeOffPopUp.removeFromSuperview()
    }
}
