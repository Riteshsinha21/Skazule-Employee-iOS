//
//  SchedulerViewModel.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/28/23.
//

import Foundation
import SwiftyJSON

protocol SchedulerViewModeling {
    func requestSchedulerApi(apiName: String, param:[String: Any], completion: @escaping (_ response: JSON)->Void)
}

class SchedulerViewModel:SchedulerViewModeling{
    func requestSchedulerApi(apiName: String, param: [String : Any], completion: @escaping (JSON) -> Void) {
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
