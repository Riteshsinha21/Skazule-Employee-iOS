//
//  ForgetPasswordViewModel.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 2/2/23.
//

import Foundation
import SwiftyJSON

protocol ForgetPasswordViewModeling {
    func verifyFields(email: String?) -> String
    func requestForgetPasswordApi(apiName: String, param:[String: Any], completion: @escaping (_ response: JSON)->Void)
}

class ForgetPasswordViewModel:ForgetPasswordViewModeling{
    
    func verifyFields(email: String?) -> String {
        
        guard let emailStr = email else { return "Please enter email" }
        if emailStr.isEmpty{
            return "Please enter email"
        }else if  !(ValidationManager.validateEmail(email: emailStr)) {
            return "Please enter valid email"
        }
        return ""
    }
    func requestForgetPasswordApi(apiName: String, param: [String : Any], completion: @escaping (JSON) -> Void) {
        ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: apiName, successBlock: { (receivedData) in
            print(receivedData)
 
            let status = receivedData["status"].stringValue //.object(forKey: "status") as! String
                if status == "1"{
                    completion(receivedData)
                } else{
                    let message = receivedData["message"].stringValue
     //              showMessageAlert(message: message)
                    completion(receivedData)
                }
          }, errorBlock: { (NSError) in
              showMessageAlert(message: kUnexpectedErrorAlertString)
          })
        }
}
