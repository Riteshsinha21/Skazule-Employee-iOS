//
//  SideMenuVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 1/31/23.
//

import UIKit

class SideMenuVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var employeeEmailLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    //MARK: VAriables
    
    
    //MARK: ViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpProfileData()
        self.configureTableView()
//        LoginVC().delegate = self
        tableView.reloadData()
        print("*****************************")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(" check !!1")
//        self.setUpProfileData()
    }
    //MARK: Private Functions
    private func setUpProfileData(){
        let empName = getEmployeeName()
        let companyName = getCompanyName()
        let email = getEmployeeEmail()
        let profilePic = getEmployeeProfilePic()
        self.employeeNameLabel.text = empName
        self.employeeEmailLabel.text = email
        self.companyNameLabel.text = companyName
        let imageUrl = IMAGE_BASE_URL + profilePic
        self.profileImage.sd_setImage(with: URL(string:imageUrl),  placeholderImage:  #imageLiteral(resourceName: "profilePlaceHolder"))
        
        // Register to receive notification in SideMenu
        NotificationCenter.default.addObserver(self, selector: #selector(openNotification(_:)), name: NSNotification.Name(rawValue: NOTIFICATION_KEYS.EMPLOYEE_DATA), object: nil)
    }
    // Function to update the profile image
    func updateProfileData(updatedData: [String:String]) {
        // Update UI elements in the side menu using updatedData
        
        print(updatedData)
        if let photo = updatedData["employeeProfilePic"] {
            // do something with your image
            let imageUrl = IMAGE_BASE_URL + photo
            self.profileImage.sd_setImage(with: URL(string:imageUrl),  placeholderImage:  #imageLiteral(resourceName: "profilePlaceHolder"))
        }
        if let employeeName = updatedData["employeeName"] {
            self.employeeNameLabel.text = employeeName
        }
        if let email = updatedData["employeeEmail"] {
            self.employeeEmailLabel.text = email
        }
        if let companyName = updatedData["employeeCompanyName"] {
            self.companyNameLabel.text = companyName
        }
    }
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SideMenuTableViewCell")
    }
    //MARK: Notification selector
    @objc func openNotification(_ notification: Notification)
    {
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            print(dict)
                        if let photo = dict["employeeProfilePic"] as? String {
                            // do something with your image
                            let imageUrl = IMAGE_BASE_URL + photo
                            self.profileImage.sd_setImage(with: URL(string:imageUrl),  placeholderImage:  #imageLiteral(resourceName: "profilePlaceHolder"))
                        }
            if let employeeName = dict["employeeName"] as? String {
                self.employeeNameLabel.text = employeeName
            }
            if let email = dict["employeeEmail"] as? String {
                self.employeeEmailLabel.text = email
            }
            if let companyName = dict["employeeCompanyName"] as? String {
                self.companyNameLabel.text = companyName
            }
        }
    }
    //MARK: Profile Button Clicked
    @IBAction func profileButtonTaped(_ sender: Any) {
        let rootController = (sideMenuViewController.rootViewController as! UINavigationController)
        var   tabbarController = UITabBarController()
        tabbarController = rootController.viewControllers.last as! UITabBarController
        removeController(rootController: rootController)
        let vc = ProfileVC()
        vc.delegate = self
        sideMenuViewController.hideLeftView(animated: true, completion: nil)
        rootController.pushViewController(vc, animated: false)
    }
    
    @IBAction func privacyPolicyButtonTaped(_ sender: Any) {
        let rootController = (sideMenuViewController.rootViewController as! UINavigationController)
        var   tabbarController = UITabBarController()
        tabbarController = rootController.viewControllers.last as! UITabBarController
        removeController(rootController: rootController)
        let vc = PrivacyPolicyVC()
        vc.isFrom = "Privacy"
        sideMenuViewController.hideLeftView(animated: true, completion: nil)
        rootController.pushViewController(vc, animated: false)
    }
    
    @IBAction func TermaAndCondiButtonTaped(_ sender: Any) {
        let rootController = (sideMenuViewController.rootViewController as! UINavigationController)
        var   tabbarController = UITabBarController()
        tabbarController = rootController.viewControllers.last as! UITabBarController
        removeController(rootController: rootController)
        let vc = PrivacyPolicyVC()
        sideMenuViewController.hideLeftView(animated: true, completion: nil)
        rootController.pushViewController(vc, animated: false)
    }
    
    
    //MARK: Logout Button Clicked
    @IBAction func logoutButtonTaped(_ sender:UIButton){
        showAlertWithYesAndCancel(title: "Message", message: KLogoutAlertMessage,viewController: self, okButtonTapped: {
            // Logout Employee
            logoutUser()
        })
    }
    
}
//MARK: Table View Data Source and Delegate methods

extension SideMenuVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitleArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as? SideMenuTableViewCell else{return UITableViewCell()}
        
        cell.congigureCell(_menuName: menuTitleArr[indexPath.row], _sideImage: menuTitleImgArr[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 //UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rootController = (sideMenuViewController.rootViewController as! UINavigationController)
        
        var   tabbarController = UITabBarController()
        
//        if  rootController.viewControllers.first is UITabBarController{
//            tabbarController = rootController.viewControllers.first as! UITabBarController
//        }
//        else if  rootController.viewControllers.last is UITabBarController{
//            tabbarController = rootController.viewControllers.last as! UITabBarController
//        }
        
        tabbarController = rootController.viewControllers.last as! UITabBarController
        removeController(rootController: rootController)
        
        switch indexPath.row{
        case 0:
            sideMenuViewController.hideLeftView(animated: true, completion: nil)
            tabbarController.selectedIndex = 2
            //            NotificationCenter.default.post(name:        NSNotification.Name("CommingFromSideMenuDashboardVC"),
            //                         object: nil)
            //rootController.pushViewController(DashboardVC(), animated: false)
            NotificationCenter.default.post(name: NSNotification.Name("CommingFromSideMenu"),object: nil)
            break
        case 1:
            sideMenuViewController.hideLeftView(animated: true, completion: nil)
            tabbarController.selectedIndex = 0
            NotificationCenter.default.post(name:        NSNotification.Name("CommingFromClockInClockOutVC"),
                                            object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("CommingFromSideMenu"),object: nil)
            break
        case 2:
            sideMenuViewController.hideLeftView(animated: true, completion: nil)
           
            tabbarController.selectedIndex = 1
        
                        NotificationCenter.default.post(name:        NSNotification.Name("CommingFromSideMenuSchedulerVC"),
                                     object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("CommingFromSideMenu"),object: nil)
        
            break
            //        case 3:
            //            sideMenuViewController.hideLeftView(animated: true, completion: nil)
            //            rootController.pushViewController(RequestTimeOffVC(), animated: false)
            //            break
        case 3:
            sideMenuViewController.hideLeftView(animated: true, completion: nil)
//            rootController.pushViewController(MySheduleVC(), animated: false)
            tabbarController.selectedIndex = 3
            break
        case 4:
            sideMenuViewController.hideLeftView(animated: true, completion: nil)
            rootController.pushViewController(RequestTimeOffVC(), animated: false)
            break
                    case 5:
                        sideMenuViewController.hideLeftView(animated: true, completion: nil)
        
 //                       NotificationCenter.default.post(name: NSNotification.Name("CommingFromSideMenu"),object: nil)
            
                        rootController.pushViewController(DocumentVC(), animated: false)
                        break
                    case 6:
//                        sideMenuViewController.hideLeftView(animated: true, completion: nil)
//                        rootController.pushViewController(BenefitsVC(), animated: false)
//                        print("BenefitsVC")
//                        break
            sideMenuViewController.hideLeftView(animated: true, completion: nil)
            tabbarController.selectedIndex = 4
            NotificationCenter.default.post(name: NSNotification.Name("CommingFromSideMenu"),object: nil)
            break
//                    case 7:
//                        sideMenuViewController.hideLeftView(animated: true, completion: nil)
//                        rootController.pushViewController(SalarySlipVC(), animated: false)
//                         print("SalarySlipVC")
//                        break
//                    case 8:
//                        sideMenuViewController.hideLeftView(animated: true, completion: nil)
//                        tabbarController.selectedIndex = 4
//                        NotificationCenter.default.post(name: NSNotification.Name("CommingFromSideMenu"),object: nil)
//                        break
//                    case 9:
//                        sideMenuViewController.hideLeftView(animated: true, completion: nil)
//            rootController.pushViewController(CompanyPolicyVC(), animated: false)
//             print("CompanyPolicyVC")
                       // tabbarController.selectedIndex = 4
                        //            NotificationCenter.default.post(name:        NSNotification.Name("CommingFromSideMenuPayrollVC"),
            //            //                         object: nil)
                        NotificationCenter.default.post(name: NSNotification.Name("CommingFromSideMenu"),object: nil)
            //            //rootController.pushViewController(PayrollVC(), animated: false)
            //            break
            //        case 10:
            //            sideMenuViewController.hideLeftView(animated: true, completion: nil)
            //            rootController.pushViewController(ChatVC(), animated: false)
            //            break
        default: break
        }
    } 
}
extension SideMenuVC:LoginDataPass{
    func loginDataPassing(dataDict: [String : String]) {
        self.setUpProfileData()
    }
}
extension SideMenuVC:ProfileUpdateDelegate{
    // Update side menu UI with the new data
    func profileDidUpdate(updatedData: [String:String]) {
        // Update UI elements in the side menu using updatedData
        
        print(updatedData)
        if let photo = updatedData["employeeProfilePic"] {
            // do something with your image
            let imageUrl = IMAGE_BASE_URL + photo
            self.profileImage.sd_setImage(with: URL(string:imageUrl),  placeholderImage:  #imageLiteral(resourceName: "profilePlaceHolder"))
        }
        if let employeeName = updatedData["employeeName"] {
            self.employeeNameLabel.text = employeeName
        }
        if let email = updatedData["employeeEmail"] {
            self.employeeEmailLabel.text = email
        }
        if let companyName = updatedData["employeeCompanyName"] {
            self.companyNameLabel.text = companyName
        }
    }
}
