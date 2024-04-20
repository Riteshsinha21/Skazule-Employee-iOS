//
//  EmployeeListResponse.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 7/24/23.
//

import Foundation


// MARK: - EmployeeListResponse

struct EmployeeListResponse : Codable{
    let totalRecordCount, status: Int?
    let error: ErrorEmpList?
    let data: [EmployeeListData]?
    let message: String?
    
    init(){
        status = nil
        data = nil
        message = nil
        error = nil
        totalRecordCount = nil
    }
}

// MARK: - EmployeeListData
struct EmployeeListData : Codable{
    let role: String?
    let timezoneGmt, tag, timezoneLocation: String?
    let cCode, maxWorkHourWeekly: String?
    let employeeID: Int?
    let shiftName: String?
    let hourlyRate: String?
    let checkOut: String?
    let mobile, email: String?
    let timezoneOffset: Int?
    let name: String?
    let checkIn: String?
    let profilePic: String?
    let status: Int?
    let position: String?
    let breakDuration: Int?
    let id: Int?
    var checkBoxSelected : Bool?
    
    enum CodingKeys: String, CodingKey {
             case id,role,tag,mobile,email,name,status,position
             case employeeID = "employee_id"
             case checkIn =    "check_in"
             case checkOut =   "check_out"
             case breakDuration = "break_duration"
             case timezoneGmt =   "timezone_gmt"
             case timezoneLocation = "timezone_location"
             case cCode =   "c_code"
             case maxWorkHourWeekly = "max_work_hour_weekly"
             case shiftName =   "shift_name"
             case hourlyRate =   "hourly_rate"
             case timezoneOffset = "timezone_offset"
             case profilePic = "profile_pic"
    }
}

//enum Role {
//    case employee
//    case manager
//    case supervisor
//}

// MARK: - Error
struct ErrorEmpList :Codable{
    
}


//struct WCEmployeeStruct
//{
//    var email: String = ""
//    var profile_pic: String = ""
//    var status: String = ""
//    var id: String = ""
//    var name: String = ""
//    var role: String = ""
//    var checkBoxSelected : Bool
//}
