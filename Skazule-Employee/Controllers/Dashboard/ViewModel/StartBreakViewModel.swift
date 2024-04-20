//
//  StartBreakViewModel.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/5/23.
//

import Foundation
import SwiftyJSON

protocol StartBreakViewModeling {
    func requestStartBreakApi(apiName: String, param:[String: Any], completion: @escaping (_ response: JSON)->Void)
}

class StartBreakViewModel:StartBreakViewModeling{
    func requestStartBreakApi(apiName: String, param: [String : Any], completion: @escaping (JSON) -> Void) {
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
