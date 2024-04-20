//
//  DashboardViewModel.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/5/23.
//

import Foundation
import SwiftyJSON

protocol DashboardViewModeling {
    func requestDashboardApi(apiName: String, param:[String: Any], completion: @escaping (_ response: JSON)->Void)
}

class DashboardViewModel:DashboardViewModeling{
    func requestDashboardApi(apiName: String, param: [String : Any], completion: @escaping (JSON) -> Void) {
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
