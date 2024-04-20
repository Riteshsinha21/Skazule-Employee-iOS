//
//  ScheduleEditViewModel.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 10/23/23.
//

import Foundation
import SwiftyJSON

protocol ScheduleEditViewModeling {
    func requestScheduleEditApi(apiName: String, param:[String: Any], completion: @escaping (_ response: JSON)->Void)
}

class ScheduleEditViewModel:ScheduleEditViewModeling{
    func requestScheduleEditApi(apiName: String, param: [String : Any], completion: @escaping (JSON) -> Void) {
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
