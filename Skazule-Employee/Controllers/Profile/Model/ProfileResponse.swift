//
//  ProfileResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/22/23.
//

import Foundation


// MARK: - ProfileResponse
struct ProfileResponse : Codable{
    let status: Int?
    let message: String?
    let data: ProfileData?
    let error: ErrorP?
    
    init(){
        status = nil
        data = nil
        message = nil
        error = nil
    }
}

// MARK: - ProfileData
struct ProfileData : Codable {
    let id, employeeID: Int?
    let name, email, cCode, mobile: String?
    let profilePic, position, colorCode, shiftName: String?
    let checkIn, checkOut: String?
    let breakDuration, timezoneOffset: Int?
    let role, hourlyRate, maxWorkHourWeekly: String?
    let timezoneLocation,timezoneGmt, empID: String?
    let logNote: String?
    let status: Int?
    let tags: [Tag]?
    let benefits: [Benefit]?
    let weekOff: [String]?
    
    enum CodingKeys: String, CodingKey {
             case id,name,email,mobile,position,role,status,tags,benefits
             case profilePic =  "profile_pic"
             case employeeID = "employee_id"
             case checkIn =    "check_in"
             case checkOut =   "check_out"
             case cCode = "c_code"
             case colorCode = "color_code"
             case shiftName =   "shift_name" 
             case breakDuration = "break_duration"
             case hourlyRate =   "hourly_rate"
             case maxWorkHourWeekly = "max_work_hour_weekly"
             case timezoneLocation =   "timezone_location"
             case timezoneGmt =   "timezone_gmt"
             case timezoneOffset = "timezone_offset"
             case empID = "emp_id"
             case logNote = "log_note"
             case weekOff = "week_off"
         }
}

// MARK: - Benefit
struct Benefit : Codable{
    let id: Int?
    let benefit, benefitDescription: String?
    let premiumPay, companyPay, employeePay, grossPay: Int?
    let status: Int?
   
    enum CodingKeys: String, CodingKey {
        case id,benefit,status
        case benefitDescription = "description"
        case premiumPay = "premium_pay"
        case companyPay = "company_pay"
        case employeePay = "employee_pay"
        case grossPay = "gross_pay"
    }
}

// MARK: - Tag
struct Tag:Codable {
    let id: Int?
    let tag: String?
}

// MARK: - Error
struct ErrorP:Codable {
}

//MARK: - Collapsible Struct

struct CellData{
    let title:String?
    let sectionData:BenefitsPlan
    var isOpened:Bool
}
struct BenefitsPlan{
    let company_pay :Int?
    let premium_pay :Int?
    let employee_pay :Int?
}
