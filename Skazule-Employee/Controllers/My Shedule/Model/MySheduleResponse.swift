//
//  MySheduleResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/17/23.
//

import Foundation



// MARK: - MySheduleResponse
//struct MySheduleResponse:Codable {
//    let status: Int?
//    let message: String?
//    let data: [MySheduleData]?
//    let error: ErrorM?
//    
//    init(){
//         status = nil
//         message = nil
//         data = nil
//         error = nil
//    }
//}
//
//// MARK: - MySheduleData
//struct MySheduleData:Codable  {
//    let scheduleID,type,status: Int?
//    let date, checkIn, note: String?
//    let breakDuration: Int?
//    let colorCode, checkOut, shiftName: String?
//    let id: Int?
//    
//    enum CodingKeys: String, CodingKey {
//        case scheduleID = "schedule_id"
//        case status,date,note,id,type
//        case checkIn = "check_in"
//        case breakDuration = "break_duration"
//        case colorCode = "color_code"
//        case checkOut = "check_out"
//        case shiftName = "shift_name"
//    }
//}
//
//// MARK: - Error
//struct ErrorM:Codable  {
//}
