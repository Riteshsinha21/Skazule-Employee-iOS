//
//  PositionResponse.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 10/25/23.
//

import Foundation


// MARK: - PositionResponse
struct PositionResponse : Codable {
    let status, totalRecordCount: Int?
    let error: ErrorPo?
    let data: [PositionData]?
    let message: String?
    
    init(){
         totalRecordCount = nil
         status = nil
         message = nil
         data = nil
         error = nil
    }
    enum CodingKeys: String, CodingKey {
             case status,message,data,error
             case totalRecordCount = "total_record_count"
         }
}

// MARK: - PositionData
struct PositionData : Codable{
    let colorCode: String?
    let industryID, id: Int?
    let checked: Bool?
    let position: String?
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        case industryID = "industry_id"
        case checked,position,status,id
        case colorCode = "color_code"
    }
}

// MARK: - Error
struct ErrorPo : Codable {
}
