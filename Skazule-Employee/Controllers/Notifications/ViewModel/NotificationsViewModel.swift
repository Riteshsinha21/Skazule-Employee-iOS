//
//  NotificationsViewModel.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 8/19/23.
//

import Foundation
import SwiftyJSON

protocol NotificationsViewModeling {
    func requestNotificationsApi(apiName: String, param:[String: Any], completion: @escaping (_ response: JSON)->Void)
}

class NotificationsViewModel:NotificationsViewModeling{
    func requestNotificationsApi(apiName: String, param: [String : Any], completion: @escaping (JSON) -> Void) {
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
