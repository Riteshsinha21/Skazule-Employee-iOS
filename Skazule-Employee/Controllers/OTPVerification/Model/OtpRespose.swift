//
//  OtpRespose.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/3/23.
//

import Foundation


// MARK: - OtpResponse
struct OtpResponse:Codable {
    let status: Int?
    let message: String?
    let data: DataClassOtp?
    let error: ErrorOtp?

    init(){
        status = nil
        data = nil
        message = nil
        error = nil
    }
}

// MARK: - DataClass
struct DataClassOtp : Codable{
    
}

// MARK: - Error
struct ErrorOtp:Codable {
    let otp: String?
}

