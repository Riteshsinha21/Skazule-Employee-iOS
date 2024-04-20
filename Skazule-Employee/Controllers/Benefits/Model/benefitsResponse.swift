//
//  benefitsResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/10/23.
//

import Foundation


// MARK: - BenefitsResponse

struct BenefitsResponse :Codable{
    let totalRecordCount, status: Int?
    let message: String?
    let data: [BenefitsData]?
    let error: ErrorB?
    
    enum CodingKeys: String, CodingKey {
             case status,message,data,error
             case totalRecordCount = "total_record_count"
         }
    
    init(){
        totalRecordCount = nil
        status = nil
        message = nil
        data = nil
        error = nil
    }
}

// MARK: - BenefitsData
struct BenefitsData : Codable{
    
    let employeeAmt: Int?
    let benefitName: String?
    let employeeID, id: Int?
    let description: String?
    let companyID, companyAmt, premiumAmt, grossAmt: Int?
    
    enum CodingKeys: String, CodingKey {
             case id,description
             case employeeAmt = "employee_amt"
             case companyAmt =  "company_amt"
             case premiumAmt = "premium_amt"
             case grossAmt = "gross_amt"
             case companyID = "company_id"
             case employeeID = "employee_id"
             case benefitName = "benefit_name"
         }
    init(){
        employeeAmt = nil
        benefitName = nil
        employeeID = nil
        id = nil
        description = nil
        companyID = nil
        companyAmt = nil
        premiumAmt = nil
        grossAmt = nil
    }
}

// MARK: - Error
struct ErrorB: Codable {
}



