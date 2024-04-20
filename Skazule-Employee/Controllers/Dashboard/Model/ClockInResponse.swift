//
//  ClockInResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/4/23.
//

import Foundation
import SwiftyJSON


// MARK: - ClockInResponse Model
struct ClockInResponse : Codable{
    let status: Int?
    let error: ErrorClockIn?
    let data: [ClockInData]?
    let message: String?
    
    init(){
        status = nil
        error = nil
        data = nil
        message = nil
    }
}

// MARK: - Clock In Data
struct ClockInData : Codable{
    let createdAt,checkIn: String?
    let shiftID,employeeID,companyID: Int?
    
    enum CodingKeys: String, CodingKey {
        case companyID = "company_id"
        case employeeID = "employee_id"
        case checkIn = "check_in"
        case createdAt = "created_at"
        case shiftID = "shift_id"
    }
}

// MARK: - Error
struct ErrorClockIn : Codable{
}

//{
//  "data" : [
//    {
//      "company_id" : "217",
//      "shift_id" : "469",
//      "employee_id" : "299",
//      "check_in" : "2023-05-19 07:35:10",
//      "created_at" : "2023-05-19 07:35:10"
//    }
//  ],
//  "error" : {
//
//  },
//  "status" : 1,
//  "message" : "You Have Checked In Successfully!"
//}



struct ShiftAvailabilityResponse : Codable{
    let status: Int?
    let error: ErrorClockIn?
    let data: [ShiftAvailabilityData]?
    let message: String?
    
    init(){
        status = nil
        error = nil
        data = nil
        message = nil
    }
}
struct ShiftAvailabilityData : Codable{
    let shiftName, checkOut, checkIn: String?
    let id,type: Int?
    
        enum CodingKeys: String, CodingKey {
                 case shiftName = "shift_name"
                 case checkIn = "check_in"
                 case checkOut = "check_out"
                 case id,type
             }
}

//{
//  "error" : {
//
//  },
//  "status" : 0,
//  "data" : [
//    {
//      "shift_name" : "afternoon 1",
//      "id" : 95,
//      "check_out" : "16:00:00",
//      "type" : 0,
//      "check_in" : "12:00:00"
//    }
//  ],
//  "message" : "Check in failed as you do not have active shift at the time!"
//}

//{
//  "status" : 1,
//  "message" : "You Have Checked In Successfully!",
//  "error" : {
//
//  },
//  "data" : [
//    {
//      "shift_id" : 91,
//      "company_id" : "217",
//      "created_at" : "2023-05-16 10:39:33",
//      "check_in" : "2023-05-16 10:39:33",
//      "employee_id" : "229"
//    }
//  ]
//}


//{
//  "error" : {
//
//  },
//  "message" : "Check in failed as you do not have active shift at the time!",
//  "status" : 0,
//  "data" : [
//    {
//      "shift_name" : "Afternoon ",
//      "check_out" : "17:00:00",
//      "check_in" : "09:00:00",
//      "type" : 0,
//      "id" : 91
//    }
//  ]
//}
