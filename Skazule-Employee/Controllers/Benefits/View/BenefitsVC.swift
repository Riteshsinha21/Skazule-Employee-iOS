//
//  BenefitsVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/10/23.
//

import UIKit

class BenefitsVC: UIViewController {
    
    
    //MARK: IBOutlets
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: VAriables
    var viewModel:BenefitsViewModel?
    var benefitsRespose = BenefitsResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        configureNavigationBar()
        configureTableView()
        self.integrateBnefitsApi()
        
    }
    //MARK: Private functions
    private func setUp(){
        self.recheckVM()
    }
    private func configureNavigationBar(){
        self.customNavigationBar.titleLabel.text = "Benefits"
        customNavigationBar.customRightBarButton.isHidden = true
        customNavigationBar.customRightBarButton.addTarget(self, action: #selector(didTapNotificationButton), for: .touchUpInside)
    }
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BenefitsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "BenefitsTableViewCell")
    }
    
    //MARK: Notification button taped
    @objc func didTapNotificationButton (_ sender:UIButton) {
        print("Notification Button is Taped")
        let vc = NotificationsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: Initialize view model
extension BenefitsVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = BenefitsViewModel()
        }
    }
}
//MARK: Table View Delegate and Data Source
extension BenefitsVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.benefitsRespose.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BenefitsTableViewCell", for: indexPath) as? BenefitsTableViewCell else{return UITableViewCell()}
        
        let info = self.benefitsRespose.data?[indexPath.row]
        cell.benefitsData = info
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = self.benefitsRespose.data?[indexPath.row]
        let vc = BenefitDetailsVC()
        vc.benefitsData = info
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: Benefits API Integration
extension BenefitsVC{
    private func integrateBnefitsApi(){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_BENEFITS_API
        let employeeId = String(getEmployeeId())
        let companyId = String(getCompanyId())
        let param:[String:String] = [ "employee_id":employeeId,"company_id":companyId]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModel?.requestBenefitsApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(BenefitsResponse.self, from: jsonData!)
                    print(responseData)
                    self?.benefitsRespose = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processBnefitsResponse(receivedData: self!.benefitsRespose)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    //MARK: Process Benefits Response
    
    func processBnefitsResponse(receivedData:BenefitsResponse){
        
        print(selectedDate)
        
        if receivedData.status == 1{
            let message = receivedData.message ?? ""
            if self.benefitsRespose.data?.count != 0{
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

