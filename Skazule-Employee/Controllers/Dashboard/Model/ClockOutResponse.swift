//
//  ClockOutResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/4/23.
//

import Foundation

// MARK: - CheckOut Response Model
struct ClockOutResponse : Codable{
    let status: Int?
    let error: ErrorCheckOut?
    let data: [String]?
    let message: String?
    
    init(){
         status = nil
         error = nil
         data = nil
         message = nil
    }
}

// MARK: - Error
struct ErrorCheckOut : Codable{
}
