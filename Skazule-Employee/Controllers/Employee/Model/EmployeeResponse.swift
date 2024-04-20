//
//  EmployeeResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/9/23.
//

import Foundation


// MARK: - EmployeeResponse
struct EmployeeResponse :Codable{
    let data: [TimeTrackData]?
    let totalRecordCount, status: Int?
    let message: String?
    let error: ErrorEmployee?
    
    enum CodingKeys: String, CodingKey {
             case status,message,data,error
             case totalRecordCount = "total_record_count"
         }
    
    init(){
            totalRecordCount = nil
            status = nil
            data = nil
            message = nil
            error = nil
        }
}

// MARK: - TimeTrackData
struct TimeTrackData :Codable{
    let checkIn, shiftName, shiftCheckIn, breakDuration: String?
    let overTime: Int?
    let date: String?
    let shiftHour: Int?
    let checkOut: String?
    let shiftCheckOut: String?
    let workingHour: Int?//String?
    let shiftType, employeeName: String?
    let shiftBreakDuration, id: Int?
    
    enum CodingKeys: String, CodingKey {
                 case id,date
                 case shiftName =  "shift_name"
                 case employeeName = "employee_name"
                 case checkIn =    "check_in"
                 case checkOut =   "check_out"
                 case shiftCheckIn = "shift_check_in"
                 case shiftCheckOut =   "shift_check_out"
                 case breakDuration = "break_duration"
                 case overTime =   "over_time"
                 case shiftHour = "shift_hour"
                 case workingHour =   "working_hour"
                 case shiftType =   "shift_type"
                 case shiftBreakDuration = "shift_break_duration"
             }
}

// MARK: - Error
struct ErrorEmployee : Codable{
    let filterFrom, filterTo: [String]?
}

