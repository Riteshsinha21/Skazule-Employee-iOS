//
//  RequestTimeOffResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/12/23.
//

import Foundation

// MARK: - RequestTimeOffResponse
struct RequestTimeOffResponse : Codable{
    let message: String?
    let status: Int?
    let error: ErrorR?
    let data: [String]?
    
    init(){
        message = nil
        status = nil
        error = nil
        data = nil
    }
}

// MARK: - Error
struct ErrorR:Codable {
    let reason: [String]?
}

//struct Welcome2 {
//    let status: Int
//    let message: String
//    let error: Error
//    let data: [Any?]
//}
//
//// MARK: - Error
//struct Error {
//    let reason: [String]
//}
