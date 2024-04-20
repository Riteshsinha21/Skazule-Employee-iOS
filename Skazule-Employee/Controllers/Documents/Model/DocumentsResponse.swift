//
//  DocumentsResponse.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/12/23.
//

import Foundation


// MARK: - DocumentsResponse
struct DocumentsResponse : Codable{
    let totalRecordCount:Int?
    let status: Int?
    let message: String?
    let data: [DocumentsData]?
    let error: ErrorDocuments?
    
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

// MARK: - DocumentsData
struct DocumentsData : Codable {
    let id: Int?
    let documentName, documentFile, fileType, createdAt: String?
    let status: Int?
    let sharedBy: String?
    
    enum CodingKeys: String, CodingKey {
             case id,status
             case documentName =  "document_name"
             case documentFile = "document_file"
             case fileType = "file_type"
             case createdAt = "created_at"
             case sharedBy = "shared_by"
         }
}

// MARK: - Error
struct ErrorDocuments:Codable{
}
