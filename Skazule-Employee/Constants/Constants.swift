//
//  Constants.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 1/30/23.
//

import Foundation
import UIKit
import MBProgressHUD
import LGSideMenuController  //1
import AVFoundation
import SwiftyJSON
import SDWebImage
import FirebaseAuth



let regularFont = UIFont.systemFont(ofSize: 16)
let boldFont = UIFont.boldSystemFont(ofSize: 16)
let IS_IPHONE_5 = UIScreen.main.bounds.width == 320
let IS_IPHONE_6 = UIScreen.main.bounds.width == 375
let IS_IPHONE_6P = UIScreen.main.bounds.width == 414
let IS_IPAD = UIScreen.main.bounds.width >= 768.0
let IS_IPAD_Mini = UIScreen.main.bounds.width == 768.0
let IS_IPAD_Pro = UIScreen.main.bounds.width == 834.0
let IS_IPAD_Pro12 = UIScreen.main.bounds.width == 1024.0

let appDelegateInstance = UIApplication.shared.delegate as! AppDelegate
let sideMenuViewController = appDelegateInstance.window?.rootViewController as! LGSideMenuController //2

let deviceType = "iOS"
let kPasswordMinimumLength = 6
let kPasswordMaximumLength = 15
let kUserFullNameMaximumLength = 56
let kPhoneNumberMaximumLength = 10
let kMessageMinimumLength = 25
let kMessageMaximumLength = 250

let selectionColor = UIColor(red: 36/255.0, green: 98/255.0, blue: 126/255.0, alpha: 1.0)
let kLostInternetConnectivityAlertString = "Your internet connection seems to be lost." as String
let kPasswordLengthAlertString = NSString(format:"The Password should consist at least %d characters.",kPasswordMinimumLength) as String
let kPasswordWhiteSpaceAlertString = "The Password should not contain any whitespaces." as String
let kUnequalPasswordsAlertString = "Both Passwords do not match." as String
let kEqualPasswordsAlertString = "Old & New Password are same." as String
let kMessageTextViewPlaceholderString = "Write your experience..." as String
let kMesssageLengthAlertString = NSString(format:"The Message should consist at least %d-%d characters.",kMessageMinimumLength,kMessageMaximumLength) as String
let kUnexpectedErrorAlertString = "An unexpected error has occurred. Please try again." as String
let kNoDataFoundAlertString = "Sorry! No data found." as String
let kChooseAnyOneOpttionAlertString = "Please choose any one option" as String
let kSignUpCaseAlertString = "Password should contains at least 1 Upper Case, 1 Lower Case, 1 number & 1 special character."
let KLogoutAlertMessage = "Are you sure, You want to Logout!"
let KDeleteLeaveRequest = "Are you sure ,You want to delete this Leave Request!"
var countryArr = [String]()


//For Staging Mode
//let BASE_URL = "https://chawtechsolutions.ch/kidyview/"
////For Live Mode
//let BASE_URL         =  "https://kidyview.com/school/"
let TRUST_BASE_URL   =  "http://chawtechsolutions.ch/kidyview/"
let IMAGE_URL        =  ""
let XAPIKEY          =  "AOmAfXgEOBiziaIZfynXNuUnnNvWnjjcoP1Qpd8S"
let GOOGLE_API_KEY = "AIzaSyAN0_zmHNLSPYyplV05EtAiDsq0A78Hi6M" // live


//struct PROJECT_URL {
//
//    //**********Login Module*************
//    static let LOGIN_API = "apiApp/parent/auth/signin"
//    static let VERIFY_OTP_API = "apiApp/parent/auth/verifyotp"
//    static let RESEND_OTP_API = "apiApp/parent/auth/resendotp"
//
//}

//struct USER_DEFAULTS_KEYS {
//    static let LOGIN_TOKEN = "loginToken"
//    static let FCM_KEY = "fcm_key"
//    
//    static let IS_LOGIN = "is_login"
//    static let IS_REMEMBER_USER = "remember_user"
//    static let EMPLOYER_EMAIL = "employer_email"
//    static let EMPLOYER_PASSWORD = "employer_password"
//    static let COMPANY_ID = "company_id"
//    static let EMPLOYER_ID = "employer_id"
//    static let INDUSTRY_ID = "industry_id"
//    static let EMPLOYEE_ID = "employee_id"
//    static let CHECK_IN = "check_in"
//}


//MARK:- Logout User
func logoutUser2() {
    UserDefaults.standard.set(false, forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
    flushUserDefaults()
    clearImageCache()
    initialiseAppWithController(LoginVC())
}
func logoutUserFromAutoLogIn() {
    UserDefaults.standard.set(false, forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
    flushUserDefaults()
    clearImageCache()
}
func logoutUser()
{
    sideMenuViewController.hideLeftView()  //.hideLeftViewAnimated()
    UserDefaults.standard.set(false, forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
    flushUserDefaults()
    clearImageCache()
    let rootController = (sideMenuViewController.rootViewController as! UINavigationController)
    
    
    removeController(rootController: rootController)
    (sideMenuViewController.rootViewController as! UINavigationController).pushViewController(LoginVC(), animated: false)
    //initialiseAppWithController(LoginVC())
}
func removeController(rootController:UINavigationController){
    for controller in rootController.viewControllers{
        if  controller is UITabBarController{
            
        }
        else{
            controller.removeFromParent()
        }
    }
}
//MARK: - Remove User Defaults
func flushUserDefaults() {
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN)
    
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.USER_ID)
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.EMPLOYEE_ID)
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.EMPLOYEE_NAME)
//    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.EMPLOYEE_EMAIL)
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.CHECK_IN)
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.COMPANY_NAME)
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.EMPLOYEE_PROFILE_PIC)
    
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.EMPLOYEE_FIREBASE_ID)
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.C_CODE)
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.FCM_KEY)
    signOutUser()
}
// MARK: Sign Out User from Firebase

func signOutUser(){
    do {
        try Auth.auth().signOut()
        // The user is now signed out.
        // You may want to navigate to the login screen or update UI accordingly.
    } catch let signOutError as NSError {
        print("Error signing out: %@", signOutError)
    }  
}
// MARK: - Initialise App  //3
func initialiseAppWithController(_ controller : UIViewController)
{
    let navigationController = UINavigationController(rootViewController: controller)
    navigationController.isNavigationBarHidden = true
    let sideMenuViewController : SideMenuVC = SideMenuVC()
    let sideMenuController = LGSideMenuController(rootViewController: navigationController, leftViewController:sideMenuViewController, rightViewController: nil)
    sideMenuController.leftViewWidth = 320.0
    sideMenuController.rootViewLayerShadowColor = .black
    //    sideMenuController.leftViewPresentationStyle = .slideBelow
    sideMenuController.isRightViewSwipeGestureEnabled = false
    sideMenuController.isLeftViewSwipeGestureEnabled = false
    appDelegateInstance.window?.rootViewController = sideMenuController
}
//func initialiseAppWithController(_ controller : UIViewController)
//{
//    let navigationController = UINavigationController(rootViewController: controller)
//    navigationController.isNavigationBarHidden = true
//    appDelegateInstance.window?.rootViewController = navigationController
//}
func loadTabBar1()->UITabBarController
{
    let tabBarController = TabBarVC()
    let employee = EmployeeVC()
    let scheduler = SchedulerVC()
    let dashboard =  DashboardVC()
    let payroll = PayRollVC()
    let workChat = WorkChatVC()
    let mySchedule = MySheduleVC()
    
    //set buttons images
    let employee_deselect = UIImage(named : "employee")
    let employee_select = UIImage(named : "employee select")
    let scheduler_deselect = UIImage(named : "employee")
    let scheduler_select = UIImage(named : "employee select")
    let dashboard_deselect = UIImage(named : "employee")
    let dashboard_select = UIImage(named : "employee select")
    let payroll_deselect = UIImage(named : "employee")
    let payroll_select = UIImage(named : "employee select")
    let workChat_deselect = UIImage(named : "employee")
    let workChat_select = UIImage(named : "employee select")
    
    // buttons for tabbar..
    let employee_Button = UITabBarItem(title: "Employee", image: employee_deselect, selectedImage: employee_select)
    let scheduler_Button = UITabBarItem(title: "Scheduler", image: scheduler_deselect, selectedImage: scheduler_select)
    let dashboard_Button = UITabBarItem(title: "", image: dashboard_deselect, selectedImage:dashboard_select)
    let payroll_Button = UITabBarItem(title: "Payroll", image: payroll_deselect, selectedImage: payroll_select)
    let workChat_Button = UITabBarItem(title: "WorkChat", image: workChat_deselect, selectedImage: workChat_select)
    
    // tabbar items..
    employee.tabBarItem = employee_Button
    scheduler.tabBarItem = scheduler_Button
    dashboard.tabBarItem = dashboard_Button
    payroll.tabBarItem = payroll_Button
    workChat.tabBarItem = workChat_Button
    
    // tabbar controllers..
    let controllers = [employee,scheduler,dashboard,payroll,workChat]
    tabBarController.setViewControllers(controllers , animated: true)
    tabBarController.selectedIndex = 2 // by default open dashboard controller
    let navViewController = UINavigationController(rootViewController: tabBarController)
    navViewController.navigationBar.isHidden = true
    return tabBarController
}

func loadTabBar()->UITabBarController
{
    let tabBarController = TabBarVC()
    let employee = EmployeeVC()
    let scheduler = SchedulerVC()
    let dashboard =  DashboardVC()
    let payroll = PayRollVC()
    let workChat = WorkChatVC()
    let mySchedule = MyScheduleNewVC()
    
    //set buttons images
//    let employee_deselect = UIImage(named : "employee")
//    let employee_select = UIImage(named : "employee_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    let employee_deselect = UIImage(named : "currently_clocked")
    let employee_select = UIImage(named : "currently_clocked_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    let scheduler_deselect = UIImage(named : "scheduler")
    let scheduler_select = UIImage(named : "scheduler_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    let payroll_deselect = UIImage(named : "payroll")
    let payroll_select = UIImage(named : "payroll_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    
    let mySchedule_deselect = UIImage(named : "my_schedule_1")
    let mySchedule_select = UIImage(named : "my_schedule_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    
    let workChat_deselect = UIImage(named : "workchat")
    let workChat_select = UIImage(named : "workchat_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    
    // buttons for tabbar..
    let employee_Button = UITabBarItem(title: "", image: employee_deselect, selectedImage: employee_select)
    let scheduler_Button = UITabBarItem(title: "", image: scheduler_deselect, selectedImage: scheduler_select)
    let payroll_Button = UITabBarItem(title: "", image: payroll_deselect, selectedImage: payroll_select)
    let mySchedule_Button = UITabBarItem(title: "", image: mySchedule_deselect, selectedImage: mySchedule_select)
    let workChat_Button = UITabBarItem(title: "", image: workChat_deselect, selectedImage: workChat_select)
    
    // tabbar items..
    employee.tabBarItem = employee_Button
    scheduler.tabBarItem = scheduler_Button
//    payroll.tabBarItem = payroll_Button
    mySchedule.tabBarItem = mySchedule_Button
    workChat.tabBarItem = workChat_Button
    
    // tabbar custom background..
    tabBarController.tabBar.backgroundColor = .clear //.white
    //tabBarController.tabBar.barTintColor    = #colorLiteral(red: 0.1490196078, green: 0.1215686275, blue: 0.1450980392, alpha: 1)
    //tabBarController.tabBar.barTintColor    = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
    let screenSize: CGRect = tabBarController.tabBar.frame
    let screenWidth = screenSize.width
    var screenHeight = screenSize.height //CGFloat(60)
//    var screenHeight = CGFloat(60)
    var isBottom: Bool {
        if #available(iOS 13.0, *), UIApplication.shared.windows[0].safeAreaInsets.bottom > 0 {
            return true
        }
        return false
    }
    if isBottom == true
    {
        screenHeight = screenHeight + 34
    }
    else
    {
        screenHeight = 60
    }
    
    let bgTabBarView = UIImageView(image: UIImage(named: "bottoom_navigation_bg"))
    bgTabBarView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: screenHeight)
    tabBarController.tabBar.addSubview(bgTabBarView)
    
    // tabbar controllers..
//    let controllers = [employee,scheduler,dashboard,payroll,workChat]
    let controllers = [employee,scheduler,dashboard,mySchedule,workChat]
    tabBarController.setViewControllers(controllers , animated: true)
    tabBarController.selectedIndex = 2 // by default open dashboard controller
    let navViewController = UINavigationController(rootViewController: tabBarController)
    navViewController.navigationBar.isHidden = true
    return tabBarController
}

//MARK:- Alert Methods
func showMessageAlert(message:String) {
    UIAlertController.showInfoAlertWithTitle("Alert", message: message , buttonTitle: "Okay")
}

func showNoDataFoundAlert() {
    UIAlertController.showInfoAlertWithTitle("", message: kNoDataFoundAlertString , buttonTitle: "Okay")
}

func showLostInternetConnectivityAlert() {
    UIAlertController.showInfoAlertWithTitle("Uh Oh!", message: kLostInternetConnectivityAlertString , buttonTitle: "Okay")
}

func showNonNumericInputErrorAlert(_ fieldName : String) {
    UIAlertController.showInfoAlertWithTitle("Error", message: String(format:"The %@ can only be numeric.",fieldName), buttonTitle: "Okay")
}

func showPasswordLengthAlert() {
    UIAlertController.showInfoAlertWithTitle("Error", message: kPasswordLengthAlertString, buttonTitle: "Okay")
}

func showPasswordWhiteSpaceAlert() {
    UIAlertController.showInfoAlertWithTitle("Error", message: kPasswordWhiteSpaceAlertString, buttonTitle: "Okay")
}

func showPasswordUnEqualAlert() {
    UIAlertController.showInfoAlertWithTitle("Error", message: kUnequalPasswordsAlertString, buttonTitle: "Okay")
}

func showPasswordEqualAlert() {
    UIAlertController.showInfoAlertWithTitle("Error", message: kEqualPasswordsAlertString, buttonTitle: "Okay")
}

func showInvalidInputAlert(_ fieldName : String) {
    UIAlertController.showInfoAlertWithTitle("Alert", message: String(format:"Please enter a valid %@.",fieldName), buttonTitle: "Okay")
}

func showMessageLengthAlert() {
    UIAlertController.showInfoAlertWithTitle("Error", message: kMesssageLengthAlertString , buttonTitle: "Okay")
}

func showSignUpCharacterCaseAlert() {
    UIAlertController.showInfoAlertWithTitle("Error", message: kSignUpCaseAlertString , buttonTitle: "Okay")
}
func showChooseAnyOneOptionAlert() {
    UIAlertController.showInfoAlertWithTitle("", message: kChooseAnyOneOpttionAlertString , buttonTitle: "Okay")
}

//MARK:- MBProgressHUD Methods
func showProgressOnView(_ view:UIView) {
    let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
    loadingNotification.mode = MBProgressHUDMode.indeterminate
    loadingNotification.label.text = "Loading.."
}

func hideProgressOnView(_ view:UIView) {
    MBProgressHUD.hide(for: view, animated: true)
}

func hideAllProgressOnView(_ view:UIView) {
    MBProgressHUD.hideAllHUDs(for: view, animated: true)
}

//MARK:-document directory realted method
public func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}
public func getImageUrl() -> URL? {
    let url = URL(fileURLWithPath: (getDirectoryPath() as NSString).appendingPathComponent("temp.jpeg"))
    return url
}

public func saveImageDocumentDirectory(usedImage:UIImage, nameStr:String) {
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(nameStr)
    let imageData = usedImage.jpegData(compressionQuality: 0.5)
    fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
}
public func saveImageDocumentDirectory(usedImage:UIImage)
{
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("temp.jpeg")
    let imageData = usedImage.jpegData(compressionQuality: 0.5)
    fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
}

func deleteDirectory(name:String){
    
    let fileManager = FileManager.default
    do {
        let documentDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURLs = try fileManager.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
        for url in fileURLs {
            try fileManager.removeItem(at: url)
        }
    } catch {
        print(error)
    }
}

//MARK:- Clear SDWebImage Cache
func clearImageCache() {
    SDImageCache.shared.clearDisk()
    SDImageCache.shared.clearMemory()
}

//MARK:- Fetch Device Width
func fetchDeviceWidth() -> CGFloat {
    if IS_IPHONE_5 {
        return 320
    } else if IS_IPHONE_6 {
        return 375
    } else if IS_IPHONE_6P{
        return 414
    }else if IS_IPAD_Mini {
        return 768
    } else if IS_IPAD_Pro {
        return 834.0
    }
    else if IS_IPAD_Pro12 {
        return 760
    }
    else {
        return 1024
    }
}
//MARK:- Fetch Device Height

func fetchDeviceHeight() -> CGFloat {
    if IS_IPHONE_5 {
        return 568
    } else if IS_IPHONE_6 {
        return 667
    } else if IS_IPHONE_6P {
        return 736
    } else if IS_IPAD_Mini {
        return 1024
    } else if IS_IPAD_Pro  {
        return 1112
    } else if IS_IPAD_Pro12  {
        return 1366
    }else {
        return 1366
    }
}

public func disableEditinginTextFieldWithTagArr(tagList:Array<Int>,targetView:UIView)
{
    for index in tagList
    {
        let txtField =  targetView.viewWithTag(index) as! UITextField
        txtField.isEnabled = false
    }
}

public func isTimeLyingBetween(target:String,from:String,to:String) -> Bool
{
    var isTimeLying = false
    let formatter = DateFormatter()
    //formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "h:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    let fromTime = formatter.date(from: from)
    let toTime = formatter.date(from: to)
    let targetTime = formatter.date(from: target)
    
    if (fromTime?.compare(targetTime!) == .orderedAscending) && (targetTime?.compare(toTime!) == .orderedAscending)
    {
        isTimeLying = true
    }
    return isTimeLying
}
public func getTimeInAmPm()-> String?
{
    let formatter = DateFormatter()
    // formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "h:mm a"
    // formatter.dateFormat = "h:mm a yyyy-MM-dd HH:mm:ss"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    
    let dateString = formatter.string(from: Date())
    print("dateInAmPm : \(dateString)")
    return dateString
}
public func getDayName()->String?
{
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let today = formatter.string(from: date)
    
    if let todayDate = formatter.date(from: today)
    {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        switch weekDay {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            print("Error fetching days")
            return "Day"
        }
    } else {
        return nil
    }
}

func getDayNameFromDate(dateStr:String) -> String {
    let formatter = DateFormatter()
    //formatter.dateFormat = "dd/MM/yyyy"
    formatter.dateFormat = "MM/dd/yyyy"
    let date = formatter.date(from: dateStr)
    formatter.dateFormat = "EEEE"
    let dayName = formatter.string(from: date!)
    return dayName
}

func getFormattedDateStr(dateStr:String) -> String
{
    let formatter = DateFormatter()
    //    formatter.dateFormat = "dd/MM/yyyy"
    formatter.dateFormat = "MM/dd/yyyy"
    let date = formatter.date(from: dateStr)
    formatter.dateFormat = "dd MMM,yyyy"
    let strdate = formatter.string(from: date!)
    return strdate
}
func getFormattedTimeStr(timeStr:String) -> String
{
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    let time = formatter.date(from: timeStr)
    formatter.dateFormat = "hh:mm:ss"
    let strdate = formatter.string(from: time!)
    return strdate
}

func convertJsonDataToSwiftyJSon(jsonData:Data?)->JSON?
{
    var  finalJson: JSON? = nil
    do
    {
        finalJson =   try JSON.init(data: jsonData!)
    }
    catch
    {}
    return finalJson
}


func convertDictionaryToJsonData(infoDict:NSDictionary)-> Data
{
    var jsonData: Data? = nil
    do
    {
        jsonData = try JSONSerialization.data(withJSONObject: infoDict as Any, options: .prettyPrinted)
    }
    catch
    {
    }
    return jsonData!
}
