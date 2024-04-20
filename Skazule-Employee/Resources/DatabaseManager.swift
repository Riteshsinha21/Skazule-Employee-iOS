//
//  DatabaseManager.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 7/19/23.
//

import Foundation
import FirebaseDatabase


final class DatabaseManager{
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
   
}

struct ChatAppUser{
    let firstName: String
    let lastName: String
    let emailAddress:String
//    let profilePictureUrl: String
  
    var safeEmail:String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    var profilePictureFileName:String{
        return("\(safeEmail)_profile_picture.png")
    }
}
//MARK: Account Manager
extension DatabaseManager{
    
//    func test(){
//        database.child("foo").setValue(["somthing" : true])
//    }
/// Insert new user
    
    public func insertUser(with user: ChatAppUser,completion:@escaping (Bool)-> Void) {
        database.child(user.safeEmail).setValue([
            "first_name":user.firstName,
            "last_name" :user.lastName
        ],withCompletionBlock: {error, _ in
            guard error == nil else{
                print("failed to write to database")
                completion(false)
                return
            }
            completion(true)
        })
    }

   public func userExits(with email:String,completion: @escaping ((Bool)-> Void)){
       
       var safeEmail = email.replacingOccurrences(of: ".", with: "-")
       safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
       
       database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
           
           guard snapshot.value as? String != nil else{
               completion(false)
               return
           }
           completion(true)
       })
       
   }
}

