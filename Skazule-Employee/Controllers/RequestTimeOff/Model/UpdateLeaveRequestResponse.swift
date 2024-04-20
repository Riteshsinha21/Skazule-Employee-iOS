//
//  UpdateLeaveRequestResponse.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 8/4/23.
//

import Foundation

// MARK: - Upade leave Request Response
struct UpdateLeaveRequestResponse : Codable{
    let message: String?
    let status: Int?
    let error: ErrorUpdateLeave?
    let data: [String]?
    
    init(){
        message = nil
        status = nil
        error = nil
        data = nil
    }
}

// MARK: - Error
struct ErrorUpdateLeave:Codable {
   // let reason: [String]?
}
