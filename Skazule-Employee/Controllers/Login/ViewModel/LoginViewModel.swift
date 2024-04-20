//
//  LoginViewModel.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 2/2/23.
//

import Foundation
import SwiftyJSON


protocol LoginViewModeling {
    func verifyFields(email: String?, password: String?) -> String
    
//    private let fdbRef = Database.database().reference()
    
//    func requestLoginApi(apiName: String, param:[String: Any], completion: @escaping (_ response: NSDictionary)->Void)
    
    func requestLoginApi(apiName: String, param:[String: Any], completion: @escaping (_ response: JSON)->Void)

//    func requestSocialLoginApi(apiName: String, param:[NSString: NSObject], method_type: methodType, completion: @escaping (_ response: NSDictionary)->Void)
}

class LoginViewModel: LoginViewModeling {

    func verifyFields(email: String?, password: String?) -> String {
        
        guard let emailStr = email else { return "Please enter email" }
        guard let passStr = password else { return "Please enter password" }
        
        if emailStr.isEmpty{
            return "Please enter email"
        }else if  !(ValidationManager.validateEmail(email: emailStr)) {
            return "Please enter valid email"
        }
        if passStr.isEmpty {
            return "Please enter password"
        }else if(passStr.count < 6)
        {
           // showMessageAlert(message: "Entered password must be atleast 6 charaters")
            return "Entered password must be atleast 6 charaters"
        }
        return ""
    }
    
    func requestLoginApi(apiName: String, param:[String: Any], completion: @escaping (_ response: JSON)->Void) {
        
        ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: apiName, successBlock: { (receivedData) in
            print(receivedData)
 
            let status = receivedData["status"].stringValue //.object(forKey: "status") as! String
                if status == "1"{
                    completion(receivedData)
                } else {
                    let message = receivedData["message"].stringValue
             //      showMessageAlert(message: message)
                    completion(receivedData)
                }
          }, errorBlock: { (NSError) in
              showMessageAlert(message: kUnexpectedErrorAlertString)
          })
        }
}
