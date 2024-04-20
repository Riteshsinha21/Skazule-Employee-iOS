//
//  RequestedSheduleResponse.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 9/28/23.
//

import Foundation


// MARK: - MySheduleResponse
struct MySheduleResponse:Codable {
    let totalRecordCount:Int?
    let status: Int?
    let message: String?
    let data: [MySheduleData]?
    let error: ErrorM?
    
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

// MARK: - MySheduleData
struct MySheduleData:Codable  {
    let scheduleID,type,status: Int?
    let date, checkIn, note: String?
    let breakDuration: Int?
    let colorCode, checkOut, shiftName: String?
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case scheduleID = "schedule_id"
        case status,date,note,id,type
        case checkIn = "check_in"
        case breakDuration = "break_duration"
        case colorCode = "color_code"
        case checkOut = "check_out"
        case shiftName = "shift_name"
    }
}

// MARK: - Error
struct ErrorM:Codable  {
}
