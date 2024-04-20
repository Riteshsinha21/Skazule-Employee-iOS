//
//  StartBreakResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/5/23.
//

import Foundation
import SwiftyJSON


// MARK: - StartBreakResponse Model
struct StartBreakResponse : Codable{
    let status: Int?
    let error: ErrorStartBreak?
    let data: [String]?
    let message: String?
    
    init(){
         status = nil
         error = nil
         data = nil
         message = nil
    }
}

// MARK: - Error
struct ErrorStartBreak : Codable{
}


//{
//  "created_at" : "2023-05-05 05:41:13",
//  "check_in" : "2023-05-05 05:41:13",
//  "breake1_duration" : 3,
//  "break3_end" : null,
//  "work_hours" : 0,
//  "breake3_duration" : 0,
//  "shift_id" : 90,
//  "updated_at" : "2023-05-05 07:40:15",
//  "break3_start" : null,
//  "company_id" : 217,
//  "check_out" : null,
//  "break1_end" : "2023-05-05 07:40:15",
//  "breake2_duration" : 0,
//  "break1_start" : "2023-05-05 07:36:54",
//  "break2_start" : "2023-05-05 07:51:29",
//  "id" : 119,
//  "employee_id" : 307,
//  "break2_end" : null
//}
