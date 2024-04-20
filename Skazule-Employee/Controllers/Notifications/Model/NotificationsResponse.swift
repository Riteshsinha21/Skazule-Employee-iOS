//
//  NotificationsResponse.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 8/19/23.
//

import Foundation

// MARK: - Notifications Response
struct NotificationsResponse : Codable{
    let totalRecordCount: Int?
    let message: String?
    let status: Int?
    let data: [NotificationsData]?
    let error: ErrorN?
    
    enum CodingKeys: String, CodingKey {
             case status,message,data,error
             case totalRecordCount = "total_record_count"
         }
    
    init(){
        status = nil
        data = nil
        message = nil
        error = nil
        totalRecordCount = nil
    }
}

// MARK: - Notifications Data
struct NotificationsData : Codable{
    let id: Int?
    let createdAt: String?
    let status: Int?
    let updatedAt: String?
    let type, title: String?
    let userID: Int?
    let data, message: String?
    let fromID: Int?
    let redirectURL: String?
    let companyID: Int?
    
    enum CodingKeys: String, CodingKey {
             case id,status,type,title,data,message
             case createdAt = "created_at"
             case updatedAt = "updated_at"
             case userID = "user_id"
             case fromID = "from_id"
             case redirectURL = "redirect_url"
             case companyID = "company_id"
    }
}

// MARK: - Error
struct ErrorN : Codable {
}
