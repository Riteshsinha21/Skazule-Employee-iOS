//
//  UpdateProfileViewModel.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 10/4/23.
//

import Foundation
import SwiftyJSON


protocol UpdateProfileViewModeling {
    func verifyFields(name: String?,email: String?,mobileNo:String?) -> String
    func requestUpdateProfileApi(apiName: String, param:[String: Any],pickedImageUrl: URL?, completion: @escaping (_ response: JSON)->Void)
}

class UpdateProfileViewModel: UpdateProfileViewModeling {
    func verifyFields(name: String?, email: String?,mobileNo:String?) -> String {
        guard let nameStr = name else { return "Please enter full name" }
        guard let emailStr = email else { return "Please enter email" }
        guard let mobileStr = mobileNo else { return "Please enter mobile no" }
        
        if nameStr.isEmpty{
            return "Please enter full name"
        }
        if emailStr.isEmpty{
            return "Please enter email"
        }else if  !(ValidationManager.validateEmail(email: emailStr)) {
            return "Please enter valid email"
        }
        if mobileStr.isEmpty {
            return "Please enter password"
        }else if !(ValidationManager.validatePhone(no: mobileStr))
        {
           // showMessageAlert(message: "Entered password must be atleast 6 charaters")
            return "Please enter valid mobile number"
        }
        return ""
    }
    
    func requestUpdateProfileApi(apiName: String, param:[String: Any],pickedImageUrl:URL? = nil, completion: @escaping (_ response: JSON)->Void) {
        
        ServerClass.sharedInstance.sendMultipartRequestToServer(urlString: apiName, fileName: "profile_pic", param, imageUrl: pickedImageUrl, successBlock: { (receivedData) in
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
