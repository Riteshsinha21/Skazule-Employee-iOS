//
//  CompanyPolicyVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/29/23.
//

import UIKit

class CompanyPolicyVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        configureNavigationBar()
        configureTableView()
        self.integrateCompanyPolicyApi()
    }
    //MARK: Private functions
    private func setUp(){
        self.recheckVM()
    }
    private func configureNavigationBar(){
        self.customNavigationBar.titleLabel.text = "Company Policy"
        customNavigationBar.customRightBarButton.isHidden = false
        customNavigationBar.customRightBarButton.addTarget(self, action: #selector(didTapNotificationButton), for: .touchUpInside)
    }
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CompanyPolicyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CompanyPolicyTableViewCell")
    }
    //MARK: Notification button taped
    @objc func didTapNotificationButton (_ sender:UIButton) {
        print("Notification Button is Taped")
    }
}
//MARK: Initialize view model
extension CompanyPolicyVC{
    // MARK: - Custom functions
    func recheckVM() {
//        if self.viewModel == nil {
//            self.viewModel = BenefitsViewModel()
//        }
    }
}
//MARK: Table View Delegate and Data Source
extension CompanyPolicyVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 //self.benefitsRespose.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyPolicyTableViewCell", for: indexPath) as? CompanyPolicyTableViewCell else{return UITableViewCell()}
        
//        let info = self.benefitsRespose.data?[indexPath.row]
//        cell.benefitsData = info
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50 //UITableView.automaticDimension
    }
}
//MARK: Benefits API Integration
extension CompanyPolicyVC{
    private func integrateCompanyPolicyApi(){
//
//        let fullUrl = BASE_URL + PROJECT_URL.GET_BENEFITS_API
//        let employeeId = String(getEmployeeId())
//        let companyId = String(getCompanyId())
//        let param:[String:String] = [ "employee_id":employeeId,"company_id":companyId]
//
//        print(param)
//        if Reachability.isConnectedToNetwork() {
//            // showProgressOnView(appDelegateInstance.window!)
//            showProgressOnView(self.view)
//            self.viewModel?.requestBenefitsApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
//                print(receivedData)
//                hideAllProgressOnView(self!.view)
//
//                do{
//                    let jsonData = self?.getDataFrom(JSON: receivedData)
//                    print(String(data: jsonData!, encoding: .utf8)!)
//                    let responseData = try JSONDecoder().decode(SalaryResponse.self, from: jsonData!)
//                    print(responseData)
//                    self?.salaryRespose = responseData
//                }catch let error{
//                    print(error.localizedDescription)
//                }
//                guard let strongSelf = self else { return }
//
//                strongSelf.processSalaryResponse(receivedData: self!.SalaryResponse)
//            })
//        }else{
//            showLostInternetConnectivityAlert()
//        }
    }
    //MARK: Process Benefits Response
    
//    func processSalaryResponse(receivedData:SalaryResponse){
//
//        print(selectedDate)
//
//        if receivedData.status == 1{
//            let message = receivedData.message ?? ""
//            if self.salaryRespose.data?.count != 0{
//                self.noDataView.isHidden = true
//                self.tableView.reloadData()
//            }else{
//                self.noDataView.isHidden = false
//            }
//        }else{
//            let message = receivedData.message
//            //          UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
//        }
//    }
}

