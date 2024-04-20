//
//  URLConstants.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 1/31/23.
//

import Foundation

struct Constants {
    static let ErrorAlertTitle = "Error"
    static let OkAlertTitle = "Ok"
    static let CancelAlertTitle = "Cancel"
}

//For Staging Mode
//let BASE_URL = "https://skazulebackend.chawtechsolutions.ch/"
//let IMAGE_BASE_URL = "https://skazulebackend.chawtechsolutions.ch/storage/app/"

// Live Mode
//let BASE_URL = "https://api.skazule.com/api/"
let BASE_URL = "https://api.skazule.com/"
let IMAGE_BASE_URL = "https://api.skazule.com/storage/app/"

//let TRUST_BASE_URL   =  "https://api.skazule.com/api/"

// IMAGE_BASE_URL = "https://api.skazule.com/storage/app/"

struct PROJECT_URL
{
    static let LOGIN_API = "api/employee-login"
    static let SIGNUP_API = "api/register-employer"
    static let FORGET_PASSWORD_API = "api/employee-forgetPassword"  
    static let VERIFY_OTP_API = "api/employee-forgetPassword"
    static let GET_DASHBOARD_DATA = "api/dashboard"
    static let CHECK_IN = "api/employee-check-in" // company_id:2, employee_id:2
    static let CHECK_OUT = "api/employee-check-out" // "company_id:2 ,employee_id:2 ,shift_id:36"
    static let START_BREAK = "api/employee-start-break" // "company_id:2, employee_id:2"
    static let END_BREAK = "api/employee-end-break" // "company_id:2, employee_id:2"
    static let REQUEST_TIME_OFF_API = "api/employee-leave-request"
    static let GET_LEAVE_TYPE = "api/get-leave-types"
    
    static let GET_EMPLOYEE_RANGE_API = "api/get-employee-range"
    static let GET_INDUSTRY_API = "api/get-industries"
    static let CREATE_COMPANY_PROFILE_API = "api/create-company-profile"

    static let GET_JOB_POSITIONS_API = "api/get-job-positions"
    static let CREATE_JOB_POSITIONS_API = "api/create-job-position"
    static let SET_COMPANY_POSITIONS_API = "api/set-company-positions"
    
    static let EMPLOYEE_SETUP_API = "api/import-employee-basics" // form data api
    
    static let SCHEDULER_SETUP_API = "api/import-shift-templates" // form data api
    //2week_start_day
    
    
    static let GET_EMPLOYEE_LIST_API = "api/get-employee-list"
    
    static let GET_COMPANY_POSITIONS_API = "api/get-company-positions" //post
    static let GET_TIMEZONE_API = "api/get-timezone"
    static let GET_COMPANY_SHIFT_API = "api/get-company-shift" //post
    static let GET_COMPANY_TAGS_API = "api/get-company-tags" //post
    static let GET_USER_ROLES_API = "api/get-user-roles"
    static let GET_BENEFITS_API = "api/benefit_list" //post
    static let GET_DOCUMENT_API = "api/company_documents_list"  // post
    static let GET_REPORTING_TO_API = "api/get-reporting-to-data" //post
    //role_id:4
    //company_id:2
    
    static let ADD_EMPLOYEE_API = "api/create-employee" //post
    static let GET_EMPLOYEE_DETAIL_API = "api/get-employee-profile-view" //post //employee_id:204
    static let UPDATE_PROFILE_API = "api/update-employee" 
    
    static let GET_EMPLOYEE_PROFILE = "api/get-employee-profile" // Post //employee_id:204
    
    static let GET_PENDING_APPROVED_DENIED_API = "api/employee_request_time_off" //post
    // status 0 for pending
    // status 1 for approve
    // status 2 for denied
    
    static let GET_MYSHEDULE_API = "api/get-my-schedules" //post
//    employee_id:176
//    filter:4
//    date_filter:2023-03-17 /optional"
    
    static let GET_CONFIRM_SCHEDULE_API = "api/confirm-schedule" // post
//    id:60
//    user_id:6"
    static let GET_SCHEDULER_API = "api/get-employee-schedules" // post
//company_id:217
//employee_id:176
//filter:4
//date_filter:2023-03-15 //optional
    static let GET_APPLYFORSCHEDULE_API = "api/apply-for-schedule" // post
//    company_id:217
//    user_id:444
//    employee_id:176
//    schedule_id:29"


   static let GET_CHECKIN_CHECKOUT_LIST_API = "api/get-employee-tracking" // Post
//company_id:217
//employee_id:299
//from_date:2023-03-22  //optional
//to_date:2023-03-23    //optional

    static let GET_DELETE_LEAVE_REQUEST_API = "api/delete-leave-request" // POST
    //id:60
    //user_id:6"
    
    static let GET_UPDATE_LEAVE_REQUEST_API = "api/update-time-off-request" //POST
//    id:120
//    employee_id:315
//    start_date:3023-06-18
//    end_date:3023-06-20
//    leave_type:3
//    reason:sssssssssssssss sss
//    user_id:10
    
    static let GET_NOTIFICATIONS_API = "api/get-notifications" //POST
//    user_id:600
//    filter:message //optional"
    
    static let GET_APPLIED_SCHEDULE_API = "api/get-my-applied-schedules"   //POST
//    "employee_id:307
//    page:0
//    limit:5
//    date_filter:2023-09-25  //optional"

static let GET_ASSIGNED_SCHEDULE_API = "api/get-my-assigned-schedules"   //POST
//    "employee_id:307
//    page:0
//    limit:5
//    date_filter:2023-09-25  //optional"

static let GET_SCHEDULE_EDIT_API = "api/schedule-edit-data" // POST
//schedule_id:114
    
}
