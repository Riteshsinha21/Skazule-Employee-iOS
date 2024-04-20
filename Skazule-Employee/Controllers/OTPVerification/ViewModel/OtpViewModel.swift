//
//  OtpViewModel.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 2/3/23.
//

import Foundation
import SwiftyJSON


protocol OtpVerificationViewModeling {
    func verifyFields(otp: String?,password:String?,confirmPassword:String?) -> String
    func requestOtpVerificationApi(apiName: String, param:[String: Any], completion: @escaping (_ response: JSON)->Void)
}

class OtpVerificationViewModel:OtpVerificationViewModeling{
    func verifyFields(otp: String?, password: String?,confirmPassword:String?) -> String {
        
        guard let otpStr = otp else { return "Please enter otp" }
        guard let passStr = password else { return "Please enter password" }
        guard let confirmPasswordStr = confirmPassword else {return "Please enter confirm password"}
        
        if otpStr.isEmpty{
            return "Please enter otp"
        }
        if passStr.isEmpty {
            return "Please enter password"
        }else if(passStr.count < 6)
        {
            showMessageAlert(message: "Entered password must be atleast 6 charaters")
        }
        if confirmPasswordStr.isEmpty{
            return "Please enter confirm password"
        }else if confirmPassword != password{
            return "Password and confirm password should be same"
        }
        return ""
    }
    
    func requestOtpVerificationApi(apiName: String, param: [String : Any], completion: @escaping (JSON) -> Void) {
        ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: apiName, successBlock: { (receivedData) in
            print(receivedData)
            
            let status = receivedData["status"].stringValue 
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
