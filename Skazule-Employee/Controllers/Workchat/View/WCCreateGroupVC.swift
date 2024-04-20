//
//  WCCreateGroupVC.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 7/21/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class WCCreateGroupVC: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var groupNameTxtField: UITextField!
    @IBOutlet weak var createGroupBtn: UIButton!
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataImage: UIImageView!
    
    //MARK: VAriables
    var isCommingFrom = ""
    var viewModel:EmployeeListViewModel?
    var employeeListRespose = EmployeeListResponse()
    
    //1 For search
    var currentSearchText: String?
    var currentSearchFieldsText: String?
    
    var employeeNameSelected = ""
//    var employeeListArr  = [WCEmployeeStruct]()
    
    //MARK: Variables
//    var customChooseImgView : CustomChooseImgView!
    let imagePicker = UIImagePickerController()
    var pickedImage : UIImage!
    var pickedImageUrl:URL?
    var groupFirebaseUrlStr = ""
    
    ///For work chat with firebase
//    private let loginUserViewModel = FireBaseManager()
    private let fdbRef = Database.database().reference()
    
    let chatViewModel = ChatViewModel()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        searchTxtField.delegate = self
        configureNavigationBar()
        configureTableView()
        self.integratEemployeeListApi()
    }
    
    //MARK: Private functions
    private func setUp(){
        self.recheckVM()
    }
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "WorkChatEmployeeListCell", bundle: Bundle.main), forCellReuseIdentifier: "WorkChatEmployeeListCell")
    }
    private func configureNavigationBar(){
        
        customNavigationBar.customRightBarButton.isHidden = true

        self.customNavigationBar.titleLabel.text = "Create Group"
    }
    //MARK: Search text changed
       @IBAction func searchTextChanged(_ sender: UITextField) {
           self.currentSearchText = sender.text
           self.integratEemployeeListApi(searchText: sender.text!)
       }
}
//MARK: Table View Delegate and Data Source
extension WCCreateGroupVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.employeeListRespose.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkChatEmployeeListCell", for: indexPath) as? WorkChatEmployeeListCell else{return UITableViewCell()}
//        cell.delegate = self
        cell.selectionStyle = .none
        let info = self.employeeListRespose.data?[indexPath.row]
        cell.isFrom = self.isCommingFrom
        cell.employeeData = info
        print(self.isCommingFrom)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 85 //UITableView.automaticDimension
    }
}
//MARK: Initialize view model
extension WCCreateGroupVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = EmployeeListViewModel()
        }
    }
}
//MARK: Employee List API Integration
extension WCCreateGroupVC{
    private func integratEemployeeListApi(searchText:String? = nil){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_EMPLOYEE_LIST_API
       
        let companyId = String(getCompanyId())
        
        var  searchStr = ""
        if let text = self.currentSearchText, text.count > 0 {
            searchStr = text
        }
//        else if let searchFieldsStr = self.currentSearchFieldsText, searchFieldsStr.count > 0 {
//            searchStr = searchFieldsStr
//        }
        searchStr = searchStr.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let param:[String:String] = ["page": "0","limit": "100","company_id":companyId,"search":"\(searchStr)"]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModel?.requestEmployeeListApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                self?.employeeListRespose = EmployeeListResponse()
                
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(EmployeeListResponse.self, from: jsonData!)
                    print(responseData)
                    self?.employeeListRespose = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }

                strongSelf.processEmployeeListResponse(receivedData: self!.employeeListRespose)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    //MARK: Process EmployeeList Response
    
    func processEmployeeListResponse(receivedData:EmployeeListResponse){
        
        print(selectedDate)
        
        if receivedData.status == 1{
            let message = receivedData.message ?? ""
            if receivedData.data?.count != 0{
                self.noDataImage.isHidden = true
                self.tableView.reloadData()
            }else{
                self.noDataImage.isHidden = false
            }
        }else{
            let message = receivedData.message
                      UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}

//MARK: Text Field Delegates
extension WCCreateGroupVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.currentSearchText = textField.text
//        self.currentSearchFieldsText = nil
        self.integratEemployeeListApi(searchText: textField.text!)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
            return true
        }
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}
