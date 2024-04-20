//
//  LeaveTypeResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/12/23.
//

import Foundation

// MARK: - Leave Type Response
struct LeaveTypeRespose : Codable {
    let error: ErrorL?
    let status: Int?
    let data: [LeaveTypeResponseData]?
    let message: String?
    init(){
        status = nil
        data = nil
        message = nil
        error = nil
    }
}

// MARK: - Leave Type ResponseData
struct LeaveTypeResponseData:Codable {
    let id: Int?
    let name: String?
}

// MARK: - Error
struct ErrorL:Codable {
}
