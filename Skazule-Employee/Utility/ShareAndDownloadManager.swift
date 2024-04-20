//
//  ShareAndDownloadManager.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/15/23.
//

import Foundation
import UIKit




func getCurrentMillis()->Int64 {
    return Int64(Date().timeIntervalSince1970 * 1000)
}
//MARK: Method to save document file
func savefile(urlString: String,viewController:UIViewController) {
    showProgressOnView(viewController.view)
    let currentTime = getCurrentMillis()
    let urlStrin = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let url = URL(string: urlStrin!)
    let fileName = String((url!.lastPathComponent)) as NSString
    let encodec_fileName = fileName.replacingOccurrences(of: " ", with: "")
    // Create destination URL
    let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
    let destinationFileUrl = documentsUrl.appendingPathComponent("\(currentTime) \(encodec_fileName)")
    //Create URL to the source file you want to download
    let fileURL = URL(string: urlStrin!)
    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig)
    let request = URLRequest(url:fileURL!)
    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
        if let tempLocalUrl = tempLocalUrl, error == nil {
            // Success
            DispatchQueue.main.async {
                hideProgressOnView(viewController.view)
            }

            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                print("Successfully downloaded. Status code: \(statusCode)")
            }

            do {
                try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                do {
                    //Show UIActivityViewController to save the downloaded file
                    let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                    for indexx in 0..<contents.count {
                        if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                            DispatchQueue.main.async {


                                let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                                viewController.present(activityViewController, animated: true, completion: nil)
                            }
                        }
                    }
                }
                catch (let err) {
                    print("error: \(err)")
                    UIAlertController.showInfoAlertWithTitle("Alert", message: err.localizedDescription, buttonTitle: "Okay")
                    hideProgressOnView(viewController.view)
                    // self.displayAlertMessage(messageToDisplay: err.localizedDescription)
                }
            } catch (let writeError) {

                hideProgressOnView(viewController.view)
                print("Error creating a file \(destinationFileUrl) : \(writeError)")
                //  self.displayAlertMessage(messageToDisplay: writeError.localizedDescription)

            }
        } else {
            hideProgressOnView(viewController.view)
            print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
        }
    }
    task.resume()
}
