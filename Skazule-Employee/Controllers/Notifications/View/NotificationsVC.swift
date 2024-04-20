//
//  NotificationsVC.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 8/19/23.
//

import UIKit


class NotificationsVC: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataImage: UIImageView!
    
    //MARK: Variables
    var viewModel:NotificationsViewModel?

    var notificationsListRespose = NotificationsResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.setUp()
        configureNavigationBar()
        configureTableView()
//        self.integratNotificationsApi()
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    //MARK: Private functions
//    private func setUp(){
//        self.recheckVM()
//    }
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NotificationsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NotificationsTableViewCell")
        tableView.reloadData()
    }
    private func configureNavigationBar(){
        customNavigationBar.customRightBarButton.isHidden = true
        self.customNavigationBar.titleLabel.text = KNotifications
    }
}
//MARK: Table View Delegate and Data Source
extension NotificationsVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationsListRespose.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as? NotificationsTableViewCell else{return UITableViewCell()}
//        cell.delegate = self
        cell.selectionStyle = .none
        let info = self.notificationsListRespose.data?[indexPath.row]
        
        print(info)
           cell.notificationData = info
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
}
//MARK: Initialize view model
//extension NotificationsVC{
//    // MARK: - Custom functions
//    func recheckVM() {
//        if self.viewModel == nil {
//            self.viewModel = NotificationsViewModel()
//        }
//    }
//}
//MARK: Notifications API Integration
//extension NotificationsVC{
//    private func integratNotificationsApi(searchText:String? = nil){
//
//        let fullUrl = BASE_URL + PROJECT_URL.GET_NOTIFICATIONS_API
//        "user_id:600
//        filter:message //optional"
       
//        let userId = String(getUserId())
//        let param:[String:String] = ["user_id":userId]
//        print(param)
//        
//        if Reachability.isConnectedToNetwork() {
//            // showProgressOnView(appDelegateInstance.window!)
//            showProgressOnView(self.view)
//            self.viewModel?.requestNotificationsApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
//                print(receivedData)
//                hideAllProgressOnView(self!.view)
//               
//
//                do{
//                    let jsonData = self?.getDataFrom(JSON: receivedData)
//                    print(String(data: jsonData!, encoding: .utf8)!)
//                    let responseData = try JSONDecoder().decode(NotificationsResponse.self, from: jsonData!)
//                    print(responseData)
//                    self!.notificationsListRespose = responseData
//                }catch let error{
//                    print(error.localizedDescription)
//                }
//                guard let strongSelf = self else { return }
//
//                strongSelf.processNotificationsResponse(receivedData:self!.notificationsListRespose)
//            })
//        }else{
//            showLostInternetConnectivityAlert()
//        }
//    }
//    //MARK: Process Notifications Response
//    
//    func processNotificationsResponse(receivedData:NotificationsResponse){
//        
//        print(selectedDate)
//        
//        if receivedData.status == 1{
//            let message = receivedData.message ?? ""
//            if receivedData.data?.count != 0{
//                self.noDataImage.isHidden = true
//                self.tableView.reloadData()
//                
//                if let notifiCount = receivedData.totalRecordCount{
//                let dataDict = ["notificationCount":notifiCount]
//                print(dataDict)
//
//                // Post Notification
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue:NOTIFICATION_KEYS.NOTIFICATION_COUNT), object: nil, userInfo: dataDict)
//                }
//            }else{
//                self.noDataImage.isHidden = false
//            }
//        }else{
//            let message = receivedData.message
//            //          UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
//        }
//    }
//}
