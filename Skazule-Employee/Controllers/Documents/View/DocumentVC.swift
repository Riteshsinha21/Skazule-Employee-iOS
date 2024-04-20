//
//  DocumentVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/12/23.
//

import UIKit



class DocumentVC: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    //MARK: VAriables
    var viewModel:DocumentsViewModel?
    var documentsRespose = DocumentsResponse()
    var currentSearchText: String?
//    var currentSearchFieldsText: String?
    var  searchStr = ""
    // For pagination 1
    var currentPage = 0
    var pageTotal = 0
    var isLoadingList : Bool = false
    var finalData = [DocumentsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        searchTextField.delegate = self
        configureNavigationBar()
        configureTableView()
        self.integrateDocumentsApi(pageNo:currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentPage = 0
        isLoadingList = false
//        self.integrateDocumentsApi(pageNo:currentPage)
    }
    //MARK: Private functions
    private func setUp(){
        self.recheckVM()
    }
    private func configureNavigationBar(){
        self.customNavigationBar.titleLabel.text = "Documents"
        customNavigationBar.customRightBarButton.isHidden = true
        customNavigationBar.customRightBarButton.addTarget(self, action: #selector(didTapNotificationButton), for: .touchUpInside)
    }
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DocumentsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DocumentsTableViewCell")
    }
    
    //MARK: Notification button taped
    @objc func didTapNotificationButton (_ sender:UIButton) {
        print("Notification Button is Taped")
        let vc = NotificationsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Search button taped
    @IBAction func searchButtonTaped(_ sender: Any) {
        if searchTextField.text != ""{
  //          self.integrateDocumentsApi(pageNo: currentPage)
            self.integrateDocumentsApi(pageNo: 0)
        }
    }
    
 //MARK: Search text changed
    @IBAction func searchTextChanged(_ sender: UITextField) {
 //       self.currentSearchFieldsText = nil
        self.currentSearchText = sender.text
 //       self.integrateDocumentsApi(searchText: sender.text!,pageNo: currentPage)
        self.integrateDocumentsApi(searchText: sender.text!,pageNo: 0)
    }
    
}
//MARK: Initialize view model
extension DocumentVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = DocumentsViewModel()
        }
    }
}
//MARK: Table View Delegate and Data Source
extension DocumentVC:UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   finalData.count  //self.documentsRespose.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentsTableViewCell", for: indexPath) as? DocumentsTableViewCell else{return UITableViewCell()}
        cell.delegate = self
        let info = self.finalData[indexPath.row]
        cell.documentData = info
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = self.finalData[indexPath.row]
        let docName = info.documentName
        if let doc = info.documentFile{
        let docUrl = IMAGE_BASE_URL + doc
    
            print(docUrl)
        let vc = ViewDocumentsVC()
            vc.urls = docUrl
            vc.docName = docName ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    // this is the method that will be called when the scrollView scrolls
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("******************************")
//
//        let pos = scrollView.contentOffset.y
//        if pos > (tableView.contentSize.height - 100 - scrollView.frame.size.height){
//            guard !self.isLoadingList else{return}
//            self.loadMoreItemsForList()
//        }
//    }
    
    // For pagination 4
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){

        if indexPath.row == (self.finalData.count - 1) {
            print(pageTotal,currentPage)

            if (self.finalData.count < (pageTotal)) && (currentPage != -1) {
                currentPage = currentPage + 1
                self.integrateDocumentsApi(pageNo:currentPage)
            }
        }
    }
}
//MARK: documents List API Integration
extension DocumentVC{
    private func integrateDocumentsApi(searchText:String? = nil,pageNo:Int){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_DOCUMENT_API
        let employeeId = String(getEmployeeId())
        let companyId = String(getCompanyId())
        
        searchStr = ""
        
        if let text = self.currentSearchText, text.count > 0 {
            searchStr = text
        }
//        else if let searchFieldsStr = self.currentSearchFieldsText, searchFieldsStr.count > 0 {
//            searchStr = searchFieldsStr
//        }
        searchStr = searchStr.trimmingCharacters(in: .whitespacesAndNewlines)
        var param:[String:Any] = [:]
        if searchStr != ""{
            param = ["page": 0,"limit": "1000", "employee_id":employeeId,"company_id":companyId,"search":"\(searchStr)"]
        }
        else{
            param = ["page": "\(pageNo)","limit": "3", "employee_id":employeeId,"company_id":companyId,"search":"\(searchStr)"]
        }
        
 //       let param:[String:String] = ["page": "\(pageNo)","limit": "1000", "employee_id":employeeId,"company_id":companyId,"search":"\(searchStr)"]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModel?.requestDocumentsApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(DocumentsResponse.self, from: jsonData!)
//                    print(responseData)
                    self?.documentsRespose = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processDocumentsResponse(receivedData: self!.documentsRespose)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    //MARK: Process Documents Response
    
    func processDocumentsResponse(receivedData:DocumentsResponse){
        
        print(selectedDate)
                
        if receivedData.status == 1{
            let message = receivedData.message ?? ""
            self.pageTotal = receivedData.totalRecordCount ?? 0
    
            // For pagination 3
            guard let ducumentsData = receivedData.data else{return}
            if (searchStr != "") || (self.currentPage == 0) {
                self.finalData.removeAll()
            }
            if self.currentPage == 0{
                self.finalData = ducumentsData
            }else{
                for item in ducumentsData{
                    self.finalData.append(item)
                }
            }
            
            DispatchQueue.main.async {
            if self.finalData.count != 0{
                self.noDataView.isHidden = true
                self.tableView.reloadData()
                }else{
                self.noDataView.isHidden = false
               }
            }
        }else{
            let message = receivedData.message
            //          UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
            
            self.noDataView.isHidden = false
        }
        
       // self.tableView.reloadData()
    }
    
    //   This is the function that increments page number and calls the API function
    func loadMoreItemsForList(){
        
        if currentPage < pageTotal{
            currentPage += 1
            //Get data from Server
            integrateDocumentsApi(pageNo: currentPage)
        }
    }
}

//MARK: Access table cell by delegate
extension DocumentVC:DocumentCellDelegate{
    func onTapDownloadDoc(cell: DocumentsTableViewCell) {
        guard let docFileStr =  cell.documentData?.documentFile else{return}
        let urlDoc = IMAGE_BASE_URL + docFileStr
        print(urlDoc)
        savefile(urlString: urlDoc,viewController: self)
    }
}
//MARK: Text Field Delegates
extension DocumentVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.currentSearchText = textField.text
//        self.currentSearchFieldsText = nil
 //       self.integrateDocumentsApi(searchText: textField.text!,pageNo: currentPage)
        self.integrateDocumentsApi(searchText: textField.text!,pageNo: 0)

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
