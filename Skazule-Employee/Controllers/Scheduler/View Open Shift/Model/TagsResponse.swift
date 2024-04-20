//
//  TagsResponse.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 9/26/23.
//

import Foundation

// MARK: - TagsResponse
struct TagsResponse :Codable {
    let status: Int?
    let message: String?
    let error: ErrorT?
    let totalRecordCount: Int?
    let data: [TagsData]?
    
    init(){
         status = nil
         message = nil
         error = nil
         totalRecordCount = nil
         data = nil
    }
    enum CodingKeys: String, CodingKey {
        case status,message,error,data
        case totalRecordCount = "total_record_count"
        
    }
}

// MARK: - Datum
struct TagsData : Codable {
    var tag = String()
    var id = Int()
//    let tag: String?
//    let id: Int?
}

// MARK: - Error
struct ErrorT : Codable{
}
