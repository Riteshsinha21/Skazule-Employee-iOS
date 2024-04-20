//
//  CustomNavigationBarForDrawer.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/13/23.
//

import UIKit

@objc protocol LeftBarButtonDrawerDelegate {
    @objc optional func leftBarButtonTapped()
}

class CustomNavigationBarForDrawer: UIView {
    
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftSideMenuButtonItem: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notificationCountLabel: UILabel!
    @IBOutlet weak var notificationView: UIView!
    
    var view : UIView?
    var delegate : LeftBarButtonDrawerDelegate?
    var senderController : UIViewController?
    
    var viewModel:NotificationsViewModel?

    var notificationsListRespose = NotificationsResponse()
    
    func xibSetup() {
        view = loadViewFromNib()
        view!.frame = bounds
        view!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view!)
        self.setUp()
//        integratNotificationsApi()
    }
    //MARK: Private functions
    private func setUp(){
        self.recheckVM()
    }
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomNavigationBarForDrawer", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    func hideLeftBarButtonItem() {
        leftSideMenuButtonItem.isHidden = true
    }
    
    //MARK: UIButton Action Methods
    
    @IBAction func leftSideMenuBtnTapped(_ sender: Any) {
        if delegate != nil {
            delegate?.leftBarButtonTapped!()
        } else { 
            sideMenuViewController.showLeftView() //.showLeftViewAnimated()

        }
    }
}
extension CustomNavigationBarForDrawer{
    
    private func integratNotificationsApi(searchText:String? = nil){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_NOTIFICATIONS_API
//        "user_id:600
//        filter:message //optional"
       
        let userId = String(getUserId())
        let param:[String:String] = ["user_id":userId]
        print(param)
        
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
//            showProgressOnView(self.view!)
            self.viewModel?.requestNotificationsApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view!)
               

                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(NotificationsResponse.self, from: jsonData!)
                    print(responseData)
                    self!.notificationsListRespose = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }

                strongSelf.processNotificationsResponse(receivedData:self!.notificationsListRespose)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    //MARK: Process Notifications Response
    
    func processNotificationsResponse(receivedData:NotificationsResponse){
        
//        print(selectedDate)
        
        if receivedData.status == 1{
            let message = receivedData.message ?? ""
            if receivedData.data?.count != 0{
//                self.noDataImage.isHidden = true
//                self.tableView.reloadData()
                
                if let notifiCount = receivedData.totalRecordCount{
                let dataDict = ["notificationCount":notifiCount]
                print(dataDict)

                notificationCountLabel.text = "\(notifiCount)"
                    
                // Post Notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:NOTIFICATION_KEYS.NOTIFICATION_COUNT), object: nil, userInfo: dataDict)
                }
            }else{
 //               self.noDataImage.isHidden = false
            }
        }else{
            let message = receivedData.message
            //          UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}
extension CustomNavigationBarForDrawer{
    func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = NotificationsViewModel()
        }
    }
}
