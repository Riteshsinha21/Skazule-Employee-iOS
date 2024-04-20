//
//  StorageManager.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 7/19/23.
//

import Foundation
import FirebaseStorage



final class StorageManager{
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
 //   public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    ///Upload picture to firebase storage and returns completion with url string to download
    
//    public func uploadProfilePicture(with data:Data,fileName:String,completion: @escaping UploadPictureCompletion){
//        storage.child("images/\(fileName)").putData(data, metadata: nil,completion: {metadata, error in
//
//            guard error == nil else {
//                //failed
//                print("faile to upload data to firebase for picture")
//                completion(.failure(StorageError.failedToUpload))
//                return
//            }
//            self.storage.child("images/\(fileName)").downloadURL(completion: {url, error in
//
//                guard let url = url else{
//                print("failed to get download url")
//                    completion(.failure(StorageError.failedToGetDownloadUrl))
//                return
//            }
//                let urlString = url.absoluteString
//                print("download url returned : \(urlString)")
//                completion(.success(urlString))
//                })
//            })
//
//        }
//        public enum StorageError:Error{
//        case failedToUpload
//        case failedToGetDownloadUrl
//        }
}
        

