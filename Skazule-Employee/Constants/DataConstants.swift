//
//  DataConstants.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/10/23.
//

import Foundation
import UIKit

//let menuTitleArr = ["Dashboard", "Clock In/Out", "Scheduler","My Schedule", "Request Time off", "Documents", "Benefits", "Salary Slip", "Work Chat", "Company Policy"]
let menuTitleArr = ["Dashboard", "Clock In/Out", "Scheduler","My Schedule", "Request Time off", "Documents","Work Chat"]
//let  menuTitleImgArr = [#imageLiteral(resourceName: "dashboard"), #imageLiteral(resourceName: "employee"), #imageLiteral(resourceName: "scheduler"), #imageLiteral(resourceName: "time_off_request"), #imageLiteral(resourceName: "time_tracking"), #imageLiteral(resourceName: "workchat"), #imageLiteral(resourceName: "bonus"), #imageLiteral(resourceName: "benefits"), #imageLiteral(resourceName: "role_responsibilties"), #imageLiteral(resourceName: "payroll")]
let  menuTitleImgArr = [#imageLiteral(resourceName: "dashboard"), #imageLiteral(resourceName: "clock_inout"), #imageLiteral(resourceName: "scheduler"), #imageLiteral(resourceName: "time_off_request"), #imageLiteral(resourceName: "time_tracking"), #imageLiteral(resourceName: "workchat"), #imageLiteral(resourceName: "role_responsibilties"),] // currently_clocked_in

let dayNameArr = ["Mon", "Tues", "Wed", "Thur", "Fri", "Sat", "Sun"]
let filterArr = ["Current Date", "Current Week"]

let KPendingStatus = "Pending"
let KConfirmedStatus = "Confirmed"
let kApprovedStatus = "Approved"
let KDeniedStatus = "Denied"
let KPendingRequest = "Pending Request"
let KApprovedRequest = "Approved Request"
let KDeniedRequest = "Denied Request"
let KZero = "0"
let KOne = "1"
let KTwo = "2"
let KThree = "3"
let KSix = "6"
let KFive = "5"
let KStart = "Start"
let KEnd = "End"
let KAllOver = "All Over"
let Kxls = "xls"
let kpdf = "pdf"
let Kxlsx = "xlsx"
let Kdocx = "docx"
let Kdoc = "doc"
let Ktxt = "txt"
let Kjpeg = "jpeg"
let kjpg =  "jpg"
let Kpng = "png"
let Kimage = "image-1"

let Kgroup = "group"
let Kindividual = "individual"
let KUPDATE = "UPDATE"
let KNotifications = "Notifications"

let KNewChat = "New Chat"
let KNewGroup = "New Group"
let KEmployeeList = "Employee List"
let KAddParticipants = "Add Participants"
let KAllreadyConfirmSchedule = "Schedule already comfirmed!"
let KNotCheckedInMessage = "You haven't checked in yet."
let kAlreadyCheckInMessage = "You have already checked In for the shift."
let KAlreadyCheckoutMessage = "You have already checked out for the shift."
let KRequestedSchedule = "Requested Schedule"
let KAssignedSchedule = "Assigned Schedule"

let FCM_SERVER_KEY   = "AAAAz8eOx3c:APA91bFR5T-Ij_ReEWqHAE_SkF-u7vTtqNiakvxgdpgo-Hq7JLJvZbtYgF_wwcgRVPn1FRIH2oGj315BgnGmcgVtSRmKI2PqxpiQ3ebE3SDrv8w31pw_hpuBSv2VUXMXcLvxNRqQflXv"


//if fileType == "pdf"
//{
//    cell.docIconImgView.image = UIImage(named: "pdf")
//}
//else if fileType == "docx"
//{
//    cell.docIconImgView.image = UIImage(named: "document")
//}
//else if fileType == "xlsx"
//{
//    cell.docIconImgView.image = UIImage(named: "xlsx")
//}
//else if fileType == "doc"
//{
//    cell.docIconImgView.image = UIImage(named: "doc")
//}
//else if fileType == "xls"
//{
//    cell.docIconImgView.image = UIImage(named: "xls")
//}
//else if fileType == "txt"
//{
//    cell.docIconImgView.image = UIImage(named: "txt")
//}
//else if (fileType == "jpeg") || (fileType == "jpg") || (fileType == "png")
//{
//    cell.docIconImgView.image = UIImage(named: "image")
//}
