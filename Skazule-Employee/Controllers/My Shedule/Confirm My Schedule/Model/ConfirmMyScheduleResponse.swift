//
//  ConfirmMyScheduleResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/2/23.
//

import Foundation
import SwiftyJSON

// MARK: - ConfirmMyScheduleResponse
struct ConfirmMyScheduleResponse: Codable{
    let status: Int?
    let error: ErrorConf?
    let message: String?
    let data: [String]?
    init(){
        status = nil
        error = nil
        message = nil
        data = nil
    }
}

// MARK: - Error
struct ErrorConf:Codable {
}
