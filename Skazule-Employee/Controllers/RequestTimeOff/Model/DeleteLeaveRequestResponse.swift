//
//  DeleteLeaveRequestResponse.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 8/3/23.
//

import Foundation


// MARK: - Delete LeaveRequest Response
struct DeleteLeaveRequestResponse : Codable{
    let message: String?
    let status: Int?
    let error: ErrorLeaveRequst?
    let data: [String]?
    
    init(){
        message = nil
        status = nil
        error = nil
        data = nil
    }
}

// MARK: - Error
struct ErrorLeaveRequst:Codable {
   // let reason: [String]?
}
