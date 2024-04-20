//
//  OtpVerificationVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 2/3/23.
//

import UIKit



class OtpVerificationVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var resendOTPButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resendOTPView: UIView!
    
    
    
    //MARK: Variables
    var viewModel:OtpVerificationViewModel?
    var viewModelForgetPassword:ForgetPasswordViewModel?
    var empEmail = ""
    var timer: Timer?
    var remainingTime = 60 // 60 seconds
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        resendOTPView.isHidden = true
    }
    func setUp(){
        self.recheckVM()
    }
    @IBAction func backButtonTaped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func eyeButtonTaped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.tag == 101{
            self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
        }
        else{
            self.confirmPasswordTextField.isSecureTextEntry = !self.confirmPasswordTextField.isSecureTextEntry
        }
    }
    @IBAction func resendOTPButtonTaped(_ sender: Any) {
        // Disable the button
        resendOTPButton.isEnabled = false
        self.resendOTPView.isHidden = false
        remainingTime = 60
        // Start the timer again
        startTimer()
    }
    
    @IBAction func verifyButtonTaped(_ sender: Any) {
        
        self.checkValidation()
    }
    func goToLoginScreen(){
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: false)
    }
    func checkValidation() {
        if let alert = self.viewModel?.verifyFields(otp: otpTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text), !alert.isEmpty {
            showMessageAlert(message: alert)
        } else {
            self.ingegrateOtpApi()
        }
    }
    func startTimer() {
        // Call Resend Otp API
        self.ingegrateForgetPasswordApi()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if remainingTime > 0 {
            self.timerLabel.text = "\(remainingTime) sec"
            remainingTime -= 1
        } else {
            // Re-enable the button after 60 seconds
            resendOTPButton.isEnabled = true
            self.resendOTPView.isHidden = true
            resendOTPButton.setTitle("Resend OTP", for: .normal)
            timer?.invalidate()
            timer = nil
        }
    }
}
extension OtpVerificationVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = OtpVerificationViewModel()
        }
        if self.viewModelForgetPassword == nil {
            self.viewModelForgetPassword = ForgetPasswordViewModel()
        }
    }
}
extension OtpVerificationVC{
    private func ingegrateOtpApi(){
        let deviceToken = getDeviceToken()
        let fullUrl = BASE_URL + PROJECT_URL.VERIFY_OTP_API
        let param:[String:String] = ["email":self.empEmail,"otp":otpTextField.text!,"password":self.passwordTextField.text!,"confirm_password":self.confirmPasswordTextField.text!]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModel?.requestOtpVerificationApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                var otpResponse = OtpResponse()
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(OtpResponse.self, from: jsonData!)
                    print(responseData)
                    otpResponse = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processOtpResponse(receivedData: otpResponse)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    func processOtpResponse(receivedData:OtpResponse){
        let message = receivedData.message ?? ""
        
        if receivedData.status == 1{
            let message = receivedData.message ?? ""
            showAlert(title: "Message", message: message,viewController: self, okButtonTapped: {
                // GOTO Login Screen
                self.goToLoginScreen()
            })
        }else{
            let message = receivedData.error?.otp
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}
extension OtpVerificationVC{
    private func ingegrateForgetPasswordApi(){
            let deviceToken = getDeviceToken()
            let fullUrl = BASE_URL + PROJECT_URL.FORGET_PASSWORD_API
            let param:[String:String] = [ "email":self.empEmail]
            
            print(param)
            if Reachability.isConnectedToNetwork() {
                // showProgressOnView(appDelegateInstance.window!)
                showProgressOnView(self.view)
                self.viewModelForgetPassword?.requestForgetPasswordApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                    print(receivedData)
                    hideAllProgressOnView(self!.view)
                    var forgetPasswordResponse = ForgetPasswordResponse()
                    do{
                        let jsonData = self?.getDataFrom(JSON: receivedData)
                        print(String(data: jsonData!, encoding: .utf8)!)
                        let responseData = try JSONDecoder().decode(ForgetPasswordResponse.self, from: jsonData!)
                        print(responseData)
                        forgetPasswordResponse = responseData
                    }catch let error{
                        print(error.localizedDescription)
                    }
                    guard let strongSelf = self else { return }
                    
                    strongSelf.processForgetPasswordResponse(receivedData: forgetPasswordResponse)
                })
            }else{
                showLostInternetConnectivityAlert()
            }
        }
    func processForgetPasswordResponse(receivedData:ForgetPasswordResponse){
//        let message = receivedData.message ?? ""
       
        if receivedData.status == 1{
            let message = receivedData.message ?? ""
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }else{
            let message = receivedData.error?.email?[0]
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}
