//
//  SchedulerResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/28/23.
//

import Foundation
import SwiftyJSON

// MARK: - SchedulerResponse
struct SchedulerResponse : Codable{
    let message: String?
    let status: Int?
    let error: ErrorS?
    let data: SchedulerData?
    
    init(){
         status = nil
         message = nil
         data = nil
         error = nil
    }
}

// MARK: - DataClass
struct SchedulerData : Codable{
    let openSchedules: [OpenSchedule]?
    
    enum CodingKeys: String, CodingKey {
    case openSchedules = "open_schedules"
 }
}

// MARK: - OpenSchedule
struct OpenSchedule : Codable{
    let nubmerOfOpening, scheduleID: Int?
    let checkOut, colorCode, note: String?
    let nubmerOfAssignedOpening: Int?
    let checkIn: String?
    let restOpening: Int?
    let date, shiftName: String?
    let breakDuration: Int?
    let position: String?
    let tags: [String]?
    
    enum CodingKeys: String, CodingKey {
        case scheduleID = "schedule_id"
        case date,note,position,tags
        case checkIn = "check_in"
        case breakDuration = "break_duration"
        case colorCode = "color_code"
        case checkOut = "check_out"
        case shiftName = "shift_name"
        case nubmerOfOpening = "nubmer_of_opening"
        case nubmerOfAssignedOpening = "nubmer_of_assigned_opening"
        case restOpening = "rest_opening"
    }
}

// MARK: - Error
struct ErrorS :Codable{
}

//{
//  "color_code" : "(80,123,211)",
//  "nubmer_of_opening" : 1,
//  "shift_name" : "open 1:40 am-2:40 am",
//  "position" : "Java developer",
//  "break_duration" : 10,
//  "rest_opening" : 0,
//  "note" : "zzzzzz ushsjsjsos ggg update",
//  "schedule_id" : 332,
//  "check_out" : "02:40:00",
//  "nubmer_of_assigned_opening" : 1,
//  "check_in" : "01:40:00",
//  "date" : "2023-04-29"
//}


