//
//  RequestTimeOffListVC.swift
//  Skazule-Employee
//
//  Created by ChawTech Solutions on 12/04/23.
//

import UIKit
import DropDown

class RequestTimeOffListVC: UIViewController {
    
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leaveTypeLabel: UILabel!
    @IBOutlet weak var noDataView: UIView!
    
    
    var profileImg = ""
    var name = ""
    var type = ""
    var deatil = ""
    var requestOn = ""
    var index = Int()
    var requestTimeOffPopUp:RequestTimeOffPopUp!
    var dataArray:[PADData]?
    var viewModelPAD: PendingApprovedDeniedViewModeling?
    var veiewModelDeleteLeaveRequest:DeleteLeaveRequestViewModeling?
    var viewModelUpdateLeaveRequest:UpdateLeaveRequestViewModeling?
    var penAppdDenRequestResponse = PendingApprovedDeniedResponse()
    
    var status = ""
    var leaveTypeData = [LeaveTypeResponseData]()
    var dropDownData = [String]()
    let dropDown = DropDown()
    var isLeaveType = false
    var requestTypeFilter = Int()
    // For pagination 1
    var currentPage = 0
    var pageTotal = 0
    var isLoadingList : Bool = false
    var finalData = [PADData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        self.configureNavigationBar()
        self.configureTableView()
        self.integratePendingApprovedDeniedApi(status: self.status,pageNo:currentPage)
    }
    //MARK: Private functions
    private func setUp(){
        self.recheckVM()
    }
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RequestTimeOffListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "RequestTimeOffListTableViewCell")
        // self.status == KZero
    }
    private func configureNavigationBar(){
        var title = ""
        switch self.status {
        case KZero: title = KPendingRequest
        case KOne: title = KApprovedRequest
        case KThree: title = KDeniedRequest
        default: print("*******")
        }
        self.customNavigationBar.titleLabel.text = title
        customNavigationBar.customRightBarButton.isHidden = true
        customNavigationBar.customRightBarButton.addTarget(self, action: #selector(didTapNotificationButton), for: .touchUpInside)
    }
    
    //MARK: Notification button taped
    @objc func didTapNotificationButton (_ sender:UIButton) {
        print("Notification Button is Taped")
        let vc = NotificationsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Down Arrow  button taped
    @IBAction func onTapDownArrow(_ sender: Any) {
        
        self.setUpDropDown1(sender as! UIButton)
    }
    //MARK: Set up Drop Down on top right
    @objc func setUpDropDown1(_ sender:UIButton){
        
        dropDownData.removeAll()
        for item in self.leaveTypeData{
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
            leaveTypeLabel.text = "\(item)"
            //           sender.setTitle("\(item)", for: .normal)
            
            if   leaveTypeLabel.text != "Select Type"{
                isLeaveType = true
                requestTypeFilter = index + 1
                self.integratePendingApprovedDeniedApi(status: status,pageNo: 0)
            }
            //       requestTimeOffPopUp.leaveTypeId = index + 1
        }
    }
    
}


//MARK: Table View Data Source and Delegate methods
extension RequestTimeOffListVC : UITableViewDataSource, UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return  dataArray?.count ?? 0  //penAppdDenRequestResponse.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RequestTimeOffListTableViewCell") as? RequestTimeOffListTableViewCell else{return UITableViewCell()}
        
        cell.delegate = self
        
        let info = dataArray?[indexPath.row] //penAppdDenRequestResponse.data?[indexPath.row]
        cell.index = indexPath.row
        
        if self.status == KZero{
            cell.status = KPendingStatus
            let textColor = UIColor.red
            cell.textColor = textColor
        }else if self.status == KOne{
            cell.status = kApprovedStatus
            let textColor = UIColor.systemGreen
            cell.textColor = textColor
        }else{
            cell.status = KDeniedStatus
            let textColor = UIColor.darkGray
            cell.textColor = textColor
        }
        cell.padData = info
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension//230
    }
    // For pagination 4
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        
        print("Scrolling Started ************")
        
        if indexPath.row == (self.dataArray!.count - 1) {
            print(pageTotal,currentPage)
            
            if (self.dataArray?.count ?? 0 < (pageTotal)) && (currentPage != -1) {
                currentPage = currentPage + 1
                self.integratePendingApprovedDeniedApi(status: status,pageNo: currentPage)
            }
        }
    }
}

extension RequestTimeOffListVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModelPAD == nil {
            self.viewModelPAD = PendingApprovedDeniedViewModel()
        }
        if self.veiewModelDeleteLeaveRequest == nil {
            self.veiewModelDeleteLeaveRequest = DeleteLeaveRequestViewModel()
        }
        if self.viewModelUpdateLeaveRequest == nil {
            self.viewModelUpdateLeaveRequest = UpdateLeaveRequestViewModel()
        }
    }
}

//MARK: Pending , Approved and Denied Api
extension RequestTimeOffListVC{
    private func integratePendingApprovedDeniedApi(status:String,pageNo:Int){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_PENDING_APPROVED_DENIED_API
        let employeeId = String(getEmployeeId())
        let companyId =  String(getCompanyId())
        var param = [String:Any]()
        
        if isLeaveType{
            param = ["company_id":companyId,"employee_id":employeeId, "status": status,"page":0,"limit":"1000","request_type_filter":"\(requestTypeFilter)"]
        }else{
            param = ["company_id":companyId,"employee_id":employeeId, "status": status,"page":"\(pageNo)","limit":"2"]
        }
        
        //        "company_id: 217
        //        employee_id: 315
        //        limit: 10
        //        page: ""0""
        //        request_type_filter: ""2"" //optional
        //        status: ""1""               //optional"
        //
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModelPAD?.requestTimeOffApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(PendingApprovedDeniedResponse.self, from: jsonData!)
                    //           print(responseData)
                    self?.penAppdDenRequestResponse = responseData
                    // self?.dataArray = self?.penAppdDenRequestResponse.data
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processPADResponse(receivedData: self!.penAppdDenRequestResponse)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    
    //MARK: Handle Pending Approved Denied Response
    func processPADResponse(receivedData:PendingApprovedDeniedResponse){
        if receivedData.status == 1{
            
            self.pageTotal = receivedData.totalRecordCount ?? 0
            guard let padData = receivedData.data else {return}
            
            if isLeaveType || (currentPage == 0){
                self.dataArray?.removeAll()
                self.dataArray = padData
            }else{
                for item in padData{
                    self.dataArray?.append(item)
                }
            }
            print(dataArray?.count)
            if self.dataArray?.count != 0{
                DispatchQueue.main.async {
 //                   self.tableView.isHidden = false
                    self.noDataView.isHidden = true
                    self.tableView.reloadData()
                }
            }else{
                self.noDataView.isHidden = false
//                tableView.isHidden = true
            }
        }else{
            self.noDataView.isHidden = false
            let message = receivedData.message ?? ""
            //  UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}

//MARK: Delete Leave Request Api
extension RequestTimeOffListVC{
    private func integrateDeleteLeaveRequestApi(id:Int){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_DELETE_LEAVE_REQUEST_API
        //        let employeeId = String(getEmployeeId())
        //        let companyId =  String(getCompanyId())
        
        let userId = String(getUserId())
        
        let param:[String:String] = ["id":"\(id)","user_id": userId]
        //        let param:[String:String] = ["id":"\(id)","user_id": employeeId]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.veiewModelDeleteLeaveRequest?.requestDeleteLeaveRequestApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                var response = DeleteLeaveRequestResponse()
                hideAllProgressOnView(self!.view)
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(DeleteLeaveRequestResponse.self, from: jsonData!)
                    print(responseData)
                    response = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processDeleteRequestResponse(receivedData: response)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    
    //MARK: Handle PendingApprovedDenied Response
    func processDeleteRequestResponse(receivedData:DeleteLeaveRequestResponse){
        if receivedData.status == 1{
            
            dataArray?.remove(at: self.index)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }else{
            let message = receivedData.message ?? ""
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}

//MARK: Access table cell by delegate
extension RequestTimeOffListVC:RequestTimeOffListCellDelegate{
    
    func onTapEdit(cell: RequestTimeOffListTableViewCell,index:Int) {
        
        guard let id = cell.padData?.id else{return}
        print("Update Cell")
        self.index = index
        guard let leaveType = cell.leaveTypeLabel.text else{return}
        print("Edit Cell")
        // Show Pop Up
        self.requestTimeOffPopUp = RequestTimeOffPopUp(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        requestTimeOffPopUp.timeOffTypeButton.setTitle(leaveType, for: .normal)
        //       requestTimeOffPopUp.leaveTypeId = self.leaveTypeResponse.data?[0].id ?? 0
        requestTimeOffPopUp.startDateTextField.text = cell.startDateLabel.text
        requestTimeOffPopUp.endDateTextField.text = cell.endDateLabel.text
        requestTimeOffPopUp.reasonTextView.text = cell.detailLabel.text
        requestTimeOffPopUp.leaveTypeId = leaveTypeData[index].id ?? 0
        requestTimeOffPopUp.id = id
        
        self.requestTimeOffPopUp.sendRequestButton.setTitle(KUPDATE, for: .normal)
        
        self.requestTimeOffPopUp.timeOffTypeButton.addTarget(self, action: #selector(self.setUpDropDown), for: .touchUpInside)
        self.requestTimeOffPopUp.sendRequestButton.addTarget(self, action: #selector(self.updateButtonTaped), for: .touchUpInside)
        self.view.addSubview(self.requestTimeOffPopUp)
    }
    
    //MARK: UPDATE Button Taped
    @objc func updateButtonTaped(_ sender: UIButton) {
        print("****")
        self.checkValidation()
    }
    
    // MARK: - Check whether fields are empty
    func checkValidation() {
        let employeeId = String(getEmployeeId())
        let companyId =  String(getCompanyId())
        
        if let alert = self.viewModelUpdateLeaveRequest?.verifyFields(companyId: companyId, employeeId: employeeId, reason: requestTimeOffPopUp.reasonTextView.text, leaveType: requestTimeOffPopUp.leaveTypeId, startDate: requestTimeOffPopUp.startDateTextField.text, endDate: requestTimeOffPopUp.endDateTextField.text), !alert.isEmpty {
            showMessageAlert(message: alert)
        } else {
            self.integrateUpdateLeaveRequestApi(id:self.requestTimeOffPopUp.id)
        }
    }
    //MARK: Set up Drop Down
    @objc func setUpDropDown(_ sender:UIButton){
        
        dropDownData.removeAll()
        for item in self.leaveTypeData{
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
    func onTapDelete(cell: RequestTimeOffListTableViewCell,index:Int) {
        guard let id = cell.padData?.id else{return}
        print("Delete Cell")
        self.index = index
        showAlertWithYesAndCancel(title: "Message", message: KDeleteLeaveRequest,viewController: self, okButtonTapped: {
            // Update Request
            self.integrateDeleteLeaveRequestApi(id:id)
        })
    }
}
//MARK: Update leave Request Api
extension RequestTimeOffListVC{
    private func integrateUpdateLeaveRequestApi(id:Int){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_UPDATE_LEAVE_REQUEST_API
        let employeeId = String(getEmployeeId())
        let userId = String(getUserId())
        
        //id:120
        //    employee_id:315
        //    start_date:3023-06-18
        //    end_date:3023-06-20
        //    leave_type:3
        //    reason:sssssssssssssss sss
        //    user_id:10
        
        
        let param:[String:Any] = ["id":"\(id)","employee_id":employeeId,"user_id":userId,"reason":requestTimeOffPopUp.reasonTextView.text!,  "leave_type":"\(requestTimeOffPopUp.leaveTypeId)","start_date":String(requestTimeOffPopUp.startDateTextField.text!),"end_date":String(requestTimeOffPopUp.endDateTextField.text!)]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModelUpdateLeaveRequest?.requestUpdateLeaveRequestApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                var response = UpdateLeaveRequestResponse()
                hideAllProgressOnView(self!.view)
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(UpdateLeaveRequestResponse.self, from: jsonData!)
                    print(responseData)
                    response = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processUpdateLeaveRequestResponse(receivedData: response)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    
    //MARK: Handle PendingApprovedDenied Response
    func processUpdateLeaveRequestResponse(receivedData:UpdateLeaveRequestResponse){
        if receivedData.status == 1{
            let message = receivedData.message ?? ""
            showAlert(title: "Message", message: message,viewController: self, okButtonTapped: {
                //Remove Pop Up
                self.integratePendingApprovedDeniedApi(status: self.status,pageNo: 0)
                self.removePopUpScreen()
            })
            //            DispatchQueue.main.async {
            //                self.tableView.reloadData()
            //            }
        }else{
            let message = receivedData.message ?? ""
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
    
    //MARK: Remove Pop Up Screen
    func removePopUpScreen(){
        self.requestTimeOffPopUp.removeFromSuperview()
    }
}
