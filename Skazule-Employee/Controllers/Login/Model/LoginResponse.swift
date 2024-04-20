//
//  LoginResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 2/1/23.
//

import Foundation


// MARK: - LoginResponse
struct LoginResponse : Codable{
    let status: Int?
    let data: DataClass?
    let message: String?
    let error :Error?
    init(){
        status = nil
        data = nil
        message = nil
        error = nil
    }
}

// MARK: - DataClass
struct DataClass : Codable{
    let employee_name: String?
    let user_id:Int?
    let email_id:String?
    let check_in: String?
    let employee_id: Int?
    let profile_pic:String?
    let company_name:String?
    let company_id: Int?
    let token: String?
    let role_id:Int?
}

// MARK: - Error
struct Error : Codable{
}


// MARK: - DataClass
//struct DataClass {
//    let companyID: Int
//    let checkIn: NSNull
//    let companyName: String
//    let userID: Int
//    let employeeName, emailID: String
//    let employeeID: Int
//    let token: String
//}
