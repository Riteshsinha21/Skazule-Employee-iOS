//
//  Common.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 2/3/23.
//

import Foundation
import SwiftyJSON


//MARK: Alert with ok button taped and doing some fuctionality

func showAlert(title: String, message: String,viewController: UIViewController? = nil, okButtonTapped: (()-> Void)? = nil) {
    
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            okButtonTapped?()
        }
        alert.addAction(okAction)
        if viewController != nil {
            viewController?.present(alert, animated: true, completion: nil)
        }
        else {
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }

   
}
func showAlertWithYesAndCancel(title: String, message: String,viewController: UIViewController? = nil, okButtonTapped: (()-> Void)? = nil) {
    
    let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
        UIAlertAction in
        okButtonTapped?()
    }
    alert.addAction(okAction)
    alert.addAction(UIAlertAction(title: "Not Now", style: .destructive, handler: { (action: UIAlertAction!) in
    }))
    if viewController != nil {
        viewController?.present(alert, animated: true, completion: nil)
    }
    else {
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
public func isTimeCompareFromCurrentTime(currentTimeStr:String,timeIn:String) -> Bool
{
    var isTimeLying = false
    
    let formatter = DateFormatter()
    //formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "h:mm a"
    let currentTime = formatter.date(from: currentTimeStr)
    let fromTime = formatter.date(from: timeIn)
    if (currentTime?.compare(fromTime!) == .orderedAscending)
    {
        isTimeLying = true
    }
    return isTimeLying
}
