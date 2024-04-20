//
//  UITableViewCell.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/26/23.
//

import Foundation
import UIKit

extension UITableViewCell{
    func localToGMTDate(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        return nil
    }

    func localToGMT(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.dateFormat = "H:mm:ss"
            return dateFormatter.string(from: date)
        }
        return nil
    }

    func gmtToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
    //    dateFormatter.dateFormat = "hh:mm:ss"
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "h:mm a"
    //        dateFormatter.dateFormat = "hh:mm:ss"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    func gmtToLocalTime(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }

    func gmtToLocalWithDate(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
            return dateFormatter.string(from: date)
        }
        return nil
    }

    func gmtToLocalDate(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-d"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    func getDateTimeFromTimeStamp(timeStamp:Double) -> String? {
        let date = NSDate(timeIntervalSince1970: timeStamp/1000)
        let dayTimePeriodFormatter = DateFormatter()
       
        dayTimePeriodFormatter.locale = Locale(identifier: "en_US_POSIX")
        dayTimePeriodFormatter.dateFormat = "MMM dd ',' hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    func convertDateTime(dateStr:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        let date = formatter.date(from: dateStr)
        formatter.dateFormat = "MMM dd ',' hh:mm a"
        let dateTimeStr = formatter.string(from: date!)
        return dateTimeStr
    }
   
}
