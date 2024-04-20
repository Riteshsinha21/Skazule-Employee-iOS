//
//  ScheduleEditResponse.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 10/23/23.
//

import Foundation
// MARK: - Welcome4
struct ScheduleEditResponse : Codable {
    let status: Int?
    let message: String?
    let data: ScheduleEditData?
    let error: ErrorSE?
    
    init(){
        status = nil
        message = nil
        data = nil
        error = nil
    }
}

// MARK: - DataClass
struct ScheduleEditData : Codable{
    let nubmerOfAssignedOpening: Int?
    let checkIn, date: String?
    let breakDuration: Int?
    let checkOut: String?
    let nubmerOfOpening: Int?
    let tags: [String]?
    let note: String?
    let requestFrom: [RequestFrom]?
    let positionID: Int?
    let colorCode: String?
    let scheduleID,employeeID: Int?
    
    enum CodingKeys: String, CodingKey {
        case scheduleID = "schedule_id"
        case employeeID = "employee_id"
        case date,note,tags
        case checkIn = "check_in"
        case breakDuration = "break_duration"
        case colorCode = "color_code"
        case checkOut = "check_out"
        case positionID = "position_id"
        case nubmerOfAssignedOpening = "nubmer_of_assigned_opening"
        case nubmerOfOpening = "nubmer_of_opening"
        case requestFrom = "request_from"
    }
}
// MARK: - RequestFrom
struct RequestFrom : Codable{
    let employeeID: Int?
    let email: String?
    let scheduleStatus: Int?
    let cCode, name, profilePic, mobile: String?
    
    enum CodingKeys: String, CodingKey {
        case email,name,mobile
        case employeeID = "employee_id"
        case scheduleStatus = "schedule_status"
        case profilePic = "profile_pic"
        case cCode = "c_code"
    }
}
// MARK: - Error
struct ErrorSE: Codable{
}
