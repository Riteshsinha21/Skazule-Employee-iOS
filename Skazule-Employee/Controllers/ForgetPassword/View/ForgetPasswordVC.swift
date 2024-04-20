//
//  ForgetPasswordVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 2/2/23.
//

import UIKit

class ForgetPasswordVC: UIViewController {

//MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    
    //MARK: VAriables
    var viewModel:ForgetPasswordViewModeling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    func setUp(){
        self.recheckVM()
    }
    @IBAction func backButtonTaped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitButtonTaped(_ sender: Any) {
        
        self.checkValidation()
    }
    func checkValidation() {
        if let alert = self.viewModel?.verifyFields(email: self.emailTextField.text), !alert.isEmpty {
            showMessageAlert(message: alert)
        } else {
            self.ingegrateForgetPasswordApi()
        }
    }
    func goToOtpVerificationScreen(){
        let vc = OtpVerificationVC()
        vc.empEmail = self.emailTextField.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension ForgetPasswordVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = ForgetPasswordViewModel()
        }
    }
}

extension ForgetPasswordVC{
    private func ingegrateForgetPasswordApi(){
            let deviceToken = getDeviceToken()
            let fullUrl = BASE_URL + PROJECT_URL.FORGET_PASSWORD_API
            let param:[String:String] = [ "email":self.emailTextField.text!]
            
            print(param)
            if Reachability.isConnectedToNetwork() {
                // showProgressOnView(appDelegateInstance.window!)
                showProgressOnView(self.view)
                self.viewModel?.requestForgetPasswordApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
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
            showAlert(title: "Message", message: message,viewController: self, okButtonTapped: {
                // Push OTP Screen
                
                self.goToOtpVerificationScreen()
            })
        }else{
            let message = receivedData.error?.email?[0]
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
        
        // ******** This commented code is to show alert without function call  **************
        //            let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        //            let OKAction = UIAlertAction(title:"Ok", style: .default) { [self] (action:UIAlertAction!) in
        // //               gotoPreviousConsult()
        //                print("Ok button tapped");}
        //            alertController.addAction(OKAction)
        //            self.present(alertController, animated: true, completion:nil)
        // ****************************************** *****************************************
    }
}
