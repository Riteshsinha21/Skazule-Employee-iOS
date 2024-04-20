//
//  ForgetPasswordResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 2/3/23.
//

import Foundation

// MARK: - ForgetPasswordResponse
struct ForgetPasswordResponse:Codable {
    let status: Int?
    let message: String?
    let data: DataClassF?
    let error: ErrorF?
    
    init(){
        status = nil
        data = nil
        message = nil
        error = nil
    }
}

// MARK: - DataClass
struct DataClassF : Codable{
    let otp: Int?
}

// MARK: - Error
//struct ErrorF :Codable{
//}
// MARK: - Error
struct ErrorF:Codable {
    let email: [String]?
}
