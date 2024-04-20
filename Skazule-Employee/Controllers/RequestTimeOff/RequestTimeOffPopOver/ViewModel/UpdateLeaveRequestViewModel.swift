//
//  UpdateLeaveRequestViewModel.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 8/4/23.
//

import Foundation
import SwiftyJSON


protocol UpdateLeaveRequestViewModeling {
    func verifyFields(companyId: String?,employeeId:String?,reason:String?,leaveType:Int?,startDate:String?,endDate:String?) -> String
    func requestUpdateLeaveRequestApi(apiName: String, param:[String: Any], completion: @escaping (_ response: JSON)->Void)
}

class UpdateLeaveRequestViewModel:UpdateLeaveRequestViewModeling{
    func verifyFields(companyId: String?,employeeId:String?,reason:String?,leaveType:Int?,startDate:String?,endDate:String?) -> String {
        
        guard let startDateStr = startDate else { return "Please select start date" }
        guard let endDateStr = endDate else { return "Please select end date" }
        guard let reasonStr = reason else {return "Please enter reason"}
        
        if startDateStr.isEmpty{
            return "Please select start date"
        }
        if endDateStr.isEmpty {
            return "Please select end date"
        }else if endDateStr < startDateStr{
            return "End Date must be greater than start date!"
        }
        if reasonStr.isEmpty{
            return "Please enter reason"
        }else if reasonStr.count < 20{
            return "The reason must be at least 20 characters."
        }
        
        return ""
    }
    
    func requestUpdateLeaveRequestApi(apiName: String, param: [String : Any], completion: @escaping (JSON) -> Void) {
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
