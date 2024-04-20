//
//  LoginVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 1/30/23.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import FirebaseMessaging



protocol LoginDataPass{
    func loginDataPassing(dataDict : [String:String])
}

class LoginVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    
    //MARK: Variables
    //    var loginResponse = LoginResponse()
    var viewModel: LoginViewModeling?
    var delegate:LoginDataPass?
    private var isRemember = false
    private let fdbRef = Database.database().reference()
    static private(set) var currentInstance: UITabBarController?
    
    //MARK: ViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.setUpData()
        self.navigationController?.navigationBar.isHidden = true
    }
    //MARK: Private functions
    
    private func setUp(){
        self.recheckVM()
    }
    private func setUpData(){
        isRemember = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.IS_REMEMBER_USER) as? Bool ?? false
        
        if isRemember{
            self.emailTextField.text = getEmployeeEmail()  //UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.EMPLOYEE_EMAIL) as? String
            self.passwordTextField.text = getEmployeePassword()  //UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.EMPLOYEE_PASSWORD) as? String
            
            self.rememberMeButton.isSelected = true
        }else{
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.rememberMeButton.isSelected = false
        }
    }
    // MARK: - Login button tapped
    @IBAction func loginButtonTaped(_ sender: Any) {
        self.checkValidation()
    }
    // MARK: - Password Hide Show button tapped
    @IBAction func eyeButtonTaped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
    }
    // MARK: - Remember Me button tapped
    @IBAction func rememberMeButtonTaped(_ sender: Any) {
        isRemember = !isRemember
        UserDefaults.standard.set(isRemember, forKey: USER_DEFAULTS_KEYS.IS_REMEMBER_USER)
        if isRemember == true{
            self.rememberMeButton.isSelected = true
            
            guard let emailText = self.emailTextField.text else{return}
            guard let passwordText = self.passwordTextField.text else{return}
            saveEmployeePassword(employeePassword: passwordText)
        }
        else{
            self.rememberMeButton.isSelected = false
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
        }
    }
    // MARK: - Forgot Password button tapped
    @IBAction func forgetPasswordButtonTaped(_ sender: Any) {
        let vc = ForgetPasswordVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Goto Dashboard
    func goToDashBoardScreen(){
      
        (sideMenuViewController.rootViewController as! UINavigationController).pushViewController(loadTabBar(), animated: false)
     //   initialiseAppWithController(loadTabBar())
    }
    // MARK: - Validate Email and  Password
    func checkValidation() {
        if let alert = self.viewModel?.verifyFields(email: self.emailTextField.text, password: self.passwordTextField.text), !alert.isEmpty {
            showMessageAlert(message: alert)
        } else {
            self.ingegrateLoginApi()
        }
    }
}
//MARK: Integrate Login Api

extension LoginVC{
    
    private func ingegrateLoginApi(){
        let deviceToken = getLoginToken()//getDeviceToken()
 //       let deviceToken = getFCMKey()// Get Firebase Token
        let fullUrl = BASE_URL + PROJECT_URL.LOGIN_API
        //        let deviceToken = "123456"
        let deviceId = "1"
        let deviceType = "iOS"
        let param:[String:String] = [ "email":self.emailTextField.text!,"password":self.passwordTextField.text!,"device_token":deviceToken,"device_type":deviceType,"device_id":deviceId]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModel?.requestLoginApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                var loginResponse = LoginResponse()
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(LoginResponse.self, from: jsonData!)
                    print(responseData)
                    loginResponse = responseData
                    //  self?.loginResponse = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processLoginResponse(receivedData: loginResponse)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    //MARK: HAndle Login response
    
    func processLoginResponse(receivedData:LoginResponse){
        if receivedData.status == 1{
            let empId = receivedData.data?.employee_id ?? 0
            let checkIn = receivedData.data?.check_in ?? ""
            let companyId = receivedData.data?.company_id ?? 0
            let token = receivedData.data?.token ?? ""
            let employeeName = receivedData.data?.employee_name ?? ""
            let employeeEmail = receivedData.data?.email_id ?? ""
            let employeeCompanyName = receivedData.data?.company_name ?? ""
            let employeeProfilePic = receivedData.data?.profile_pic ?? ""
            let userId = receivedData.data?.user_id ?? 0
            let roleId = receivedData.data?.role_id ?? 0
        
            
            //save data in userdefault..
            
             saveLoginToken(token: token)
             saveIsLogin(isLogin: true)
            
             saveCompanyId(companyId: companyId)
             saveEmployeeId(employeeId: empId)
             saveEmployeeCheckIn(employeeCheckIn: checkIn)
             saveEmployeeName(employeeName: employeeName)
             saveEmployeeEmail(employeeEmail: employeeEmail)
             saveCompanyName(companyName: employeeCompanyName)
             saveEmployeeProfilePic(employeeProfilePic: employeeProfilePic)
           
             saveUserId(userId: userId)
             saveRoleId(roleId: roleId)

        
// ********** Pass data to Side Menue By Notification Center *************
            let dataDict = ["employeeName":employeeName,"employeeEmail":employeeEmail,"employeeCompanyName":employeeCompanyName,"employeeProfilePic":employeeProfilePic]
 //          self.delegate?.loginDataPassing(dataDict: dataDict)
            print(dataDict)
            
//            let sideMenuVC = SideMenuVC()
//            sideMenuVC.updateProfileData(updatedData: dataDict)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:NOTIFICATION_KEYS.EMPLOYEE_DATA), object: nil, userInfo: dataDict)
            
            
  //************ Sign Up and Login with Firebase    ****************************
            let imageUrl =  IMAGE_BASE_URL + employeeProfilePic
            DispatchQueue.main.async{
                if employeeEmail != ""{
                  //  let timestamp = Int(Date().timeIntervalSince1970*1000)
                    self.getUserInfo(email: employeeEmail, password: self.passwordTextField.text!, userName: employeeName, profilePic: imageUrl)
          //   self.signUpIntoFirebase(email: employeeEmail, userId: "ID", userName: employeeName, profile: imageUrl, timestamp: String(timestamp), role: "Employee")
                }
            }
            self.goToDashBoardScreen()
        }else{
            let message = receivedData.message ?? ""
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
    private func getUserInfo(email: String, password: String, userName: String, profilePic: String){
        
        if let token = Messaging.messaging().fcmToken {
            print("FCM TOKEN \(token)")
            saveFCMKey(fcmKey: token)
        }
        
        let fcmKey = getFCMKey()//UserDefaults.standard.string(forKey: USER_DEFAULTS_KEYS.FCM_KEY)
        
        print(fcmKey)
        let timestamp = Int(Date().timeIntervalSince1970*1000)
        
        fdbRef.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists(){
                if let dataDict = snapshot.value as? [String:AnyObject]{
                    
                    for (key,_) in dataDict {
                        
                        let emailStr  = dataDict[key]!["email"] as? String
                        let userId    = dataDict[key]!["userId"] as? String
                        if emailStr != email{
                            self.signUpIntoFirebase(email: email, userId: "ID", userName: userName, profile: profilePic, timestamp: String(timestamp), role: "Employee")
                        }else{
                            //userId
                            saveFirebaseUserId(userId: userId ?? "")
          //                  UserDefaults.standard.setValue(userId, forKey: USER_DEFAULTS_KEYS.EMPLOYEE_FIREBASE_ID)
                            var chatDict: [String:AnyObject] = [:]
                            chatDict = [
                                "fcmKey" : fcmKey
                            ] as [String : AnyObject]
                            
                            if userId != ""{
                                self.fdbRef.child("Users").child("\(userId!)").updateChildValues(chatDict)
                            }
                        }
                    }
                }
            }
            else
            {
                self.signUpIntoFirebase(email: email, userId: "ID", userName: userName, profile: profilePic, timestamp: String(timestamp), role: "Employee")
            }
        }
    }
}

extension LoginVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = LoginViewModel()
        }
    }
}
//MARK: Firebase Sign Up Login

extension LoginVC{
       
        private func signUpIntoFirebase(email:String, userId:String, userName:String, profile:String, timestamp : String, role : String) {
            
            let pass = getEmployeePassword()//UserDefaults.standard.string(forKey: USER_DEFAULTS_KEYS.EMPLOYEE_PASSWORD) ?? ""
            
            FireBaseManager.shared.signUpWithFirebase(email: email, password: pass, userId : userId, userName : userName, profile:profile, timestamp:timestamp, role:role) { (success) in
                
                //guard let userId = Auth.auth().currentUser?.uid  else { return }
                //save Employer Firebase userId in userdefault..
                //UserDefaults.standard.setValue(userId, forKey: USER_DEFAULTS_KEYS.FIREBASE_EMPLOYER_USER_ID)
              
                    print("Singed Up with firebase successfully")
                
                self.loginWithFirebase(email:email, userId:userId, userName:userName, profile:profile, timestamp:timestamp, role:role)
            } onError: { (errorMessage) in
                DispatchQueue.main.async {
                    hideProgressOnView(self.view)
                    showMessageAlert(message: errorMessage)
                }
            }
        }
        
        private func loginWithFirebase(email:String, userId:String, userName:String, profile:String, timestamp : String, role : String){
            
            let pass = getEmployeePassword()
            
            FireBaseManager.shared.loginWithFirebase(email: email, userId: userId, userName: userName, profile: profile, timestamp: timestamp, role: role) { (success) in
                //  if self.user != nil{
                //self.saveDataToUserDefaults(user: self.user!)
            
                DispatchQueue.main.async {
                    hideProgressOnView(self.view)
                    print("Logged in with firebase successfully")
   //                 self.goToDashBoardScreen()
                }
            } onError: { (errorMessage) in
                DispatchQueue.main.async {
                    hideProgressOnView(self.view)
                    showMessageAlert(message: errorMessage)
                }
            }
        }
}
