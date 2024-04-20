//
//  DashboardResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/5/23.
//

import Foundation


// MARK: - DashBoardResponse
struct DashBoardResponse :Codable {
    let error: ErrorD?
    let data: DashBoardResponseData?
    let status: Int?
    let message: String?
    
    init(){
        status = nil
        data = nil
        message = nil
        error = nil
    }
}

// MARK: - DataClass
struct DashBoardResponseData :Codable  {
    let chekinData: [ChekinData]?
    let openShift: [OpenShift]?
    
    init(){
        chekinData = nil
        openShift = nil
    }
    enum CodingKeys: String, CodingKey {
             case chekinData
             case openShift =  "open_shift"
         }
}

// MARK: - ChekinData
struct ChekinData :Codable {
    let breake2Duration: Int?
    let checkOut: String?
    let workHours: Int?
    let break2Start: String?
    let updatedAt: String?
    let id, companyID, breake3Duration: Int?
    let break3End, break3Start: String?
    let createdAt: String?
    let break1End: String?
    let checkIn: String?
    let employeeID, shiftID, breake1Duration: Int?
    let break1Start: String?
    let break2End: String?
    
    enum CodingKeys: String, CodingKey {
             case id
             case companyID =  "company_id"
             case employeeID = "employee_id"
             case checkIn =    "check_in"
             case checkOut =   "check_out"
             case break1Start = "break1_start"
             case break1End =   "break1_end"
             case break2Start = "break2_start"
             case break2End =   "break2_end"
             case break3Start = "break3_start"
             case break3End =   "break3_end"
             case workHours =   "work_hours"
             case breake1Duration = "breake1_duration"
             case breake2Duration = "breake2_duration"
             case breake3Duration = "breake3_duration"
             case createdAt = "created_at"
             case updatedAt = "updated_at"
             case shiftID = "shift_id"
         }
}

// MARK: - OpenShift
struct OpenShift :Codable {
    let position, checkOut, shiftName: String?
    let note: String?
    let nubmerOfAssignedOpening, nubmerOfOpening: Int?
    let checkIn, date: String?
    let breakDuration, scheduleID: Int?
    let colorCode: String?
    let tags: [String]?
    
    init(){
        position = nil
        note = nil
        date = nil
        shiftName = nil
        nubmerOfAssignedOpening = nil
        nubmerOfOpening = nil
        checkIn = nil
        checkOut = nil
        scheduleID = nil
        breakDuration = nil
        colorCode = nil
        tags = nil
    }
    
    
    enum CodingKeys: String, CodingKey {
             case position,note,date,tags
             case shiftName =  "shift_name"
             case nubmerOfAssignedOpening = "nubmer_of_assigned_opening"
             case nubmerOfOpening = "nubmer_of_opening"
             case checkIn =    "check_in"
             case checkOut =   "check_out"
             case breakDuration = "break_duration"
             case scheduleID = "schedule_id"
             case colorCode =   "color_code"
         }
}

// MARK: - Error
struct ErrorD :Codable {
    
}

/*
// MARK: - DashBoardResponse
struct DashBoardResponse:Codable {
    let data: [DashBoardResponseData]?
    let error: ErrorD?
    let message: String?
    let status: Int?
    
    init(){
        status = nil
        data = nil
        message = nil
        error = nil
    }
}

// MARK: - DashBoardResponseData
struct DashBoardResponseData : Codable{
    let breake2Duration, id: Int?
    let updatedAt, checkOut, break3Start: String?
    let companyID: Int?
    let break1Start, break2Start:  String?
    let breake1Duration, shiftID: Int?
    let createdAt: String
    let employeeID: Int
    let break3End:  String?
    let checkIn: String?
    let workHours, breake3Duration: Int?
    let break2End, break1End:String?
    
    enum CodingKeys: String, CodingKey {
             case id
             case companyID =  "company_id"
             case employeeID = "employee_id"
             case checkIn =    "check_in"
             case checkOut =   "check_out"
             case break1Start = "break1_start"
             case break1End =   "break1_end"
             case break2Start = "break2_start"
             case break2End =   "break2_end"
             case break3Start = "break3_start"
             case break3End =   "break3_end"
             case workHours =   "work_hours"
             case breake1Duration = "breake1_duration"
             case breake2Duration = "breake2_duration"
             case breake3Duration = "breake3_duration"
             case createdAt = "created_at"
             case updatedAt = "updated_at"
             case shiftID = "shift_id"
         }
}

// MARK: - Error
struct ErrorD : Codable {
}

*/

