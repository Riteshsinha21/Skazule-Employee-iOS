//
//  PendingApprovedDeniedResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/13/23.
//

import Foundation

// MARK: - Welcome
struct PendingApprovedDeniedResponse: Codable {
    let totalRecordCount:Int?
    let status: Int?
    let message: String?
    let data: [PADData]?
    let error: ErrorC?
    
    enum CodingKeys: String, CodingKey {
             case status,message,data,error
             case totalRecordCount = "total_record_count"
         }
    
    init(){
        totalRecordCount = nil
        status = nil
        data = nil
        message = nil
        error = nil
    }
}

// MARK: - Datum
struct PADData: Codable {
    let id, employeeID: Int?
    let employeeName, email, cCode, mobile: String?
    let profilePic, reason, startDate, endDate: String?
    let leaveTypeId: Int?
    let createdAt: String?
    let leaveTypeName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case employeeID = "employee_id"
        case employeeName = "employee_name"
        case email
        case cCode = "c_code"
        case mobile
        case profilePic = "profile_pic"
        case reason
        case startDate = "start_date"
        case endDate = "end_date"
        case leaveTypeId = "leave_type_id"
        case leaveTypeName =  "leave_type_name"
        case createdAt = "created_at"
    }
}
// MARK: - Error
struct ErrorC:Codable {
}
