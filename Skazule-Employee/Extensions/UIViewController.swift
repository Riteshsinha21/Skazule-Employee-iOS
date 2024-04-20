//
//  UIViewController.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 2/2/23.
//

import Foundation
import SwiftyJSON

extension UIViewController{
    
 //MARK: Convert JSON to Data
    
    func getDataFrom(JSON json: JSON) -> Data? {
        do {
            return try json.rawData(options: .prettyPrinted)
        } catch _ {
            return nil
        }
    }
    
    
//MARK: -Toast Message
  
    func showToast(message : String, font: UIFont) {

   //     let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        
        let toastLabel = UILabel(frame: CGRect(x: 20, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 40, height: 35))
        
        toastLabel.backgroundColor = .black
        toastLabel.textColor = .black
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
        func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
            //image.draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
            image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height))  )
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return newImage
        }
        
        func maskRoundedImage(image: UIImage, radius: CGFloat) -> UIImage {
            let imageView: UIImageView = UIImageView(image: image)
            let layer = imageView.layer
            layer.masksToBounds = true
            layer.cornerRadius = radius
            UIGraphicsBeginImageContext(imageView.bounds.size)
            layer.render(in: UIGraphicsGetCurrentContext()!)
            let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return roundedImage!
        }
    func getDayFromDate(dateString: String, dateFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: dateString)
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat  = "EEEE"//"EE" to get short style
        return date != nil ? dateFormat.string(from: date!) : "" //"Sunday"
    }
    
    func getMonthFromDate(dateString: String, dateFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: dateString)
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat  = "LLLL"//"EE" to get short style
        return date != nil ? dateFormat.string(from: date!) : "" //"January"
    }
    
    func currentDate() -> String
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        let currentDate = formatter.string(from: date)
        return currentDate
    }
    func currentDateWithFormater2() -> String
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: date)
        return currentDate
    }
    func dateWithFormater2(selectedDate:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = formatter.string(from: selectedDate)
        return selectedDate
    }
//    func dateWithFormater2(selectedDate:String) -> String{
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let selectedDate = formatter.string(from: selectedDate)
//        return selectedDate
//    }
    func dateWithFormater3(selectedDate:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let selectedDate = formatter.string(from: selectedDate)
        return selectedDate
    }
    func selectedDate(selectDate:Date) -> String
    {
        let date = selectDate
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        let currentDate = formatter.string(from: date)
        return currentDate
    }
    func selectedDateByCurrentWeek(dateStr:String) -> String {
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateStr)
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        let dayName = formatter.string(from: date!)
        return dayName
    }
    func currentDateShowInCalender(dateStr:String) -> String {
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateStr)
        formatter.dateFormat = "MMM d, yyyy"
        let dayName = formatter.string(from: date!)
        return dayName
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
    func gmtToLocalDate(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    func gmtToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
    extension Calendar {
        static let iso8601 = Calendar(identifier: .iso8601)
        static let gregorian = Calendar(identifier: .gregorian)
    }
    extension Date {
        func byAdding(component: Calendar.Component, value: Int, wrappingComponents: Bool = false, using calendar: Calendar = .current) -> Date? {
            calendar.date(byAdding: component, value: value, to: self, wrappingComponents: wrappingComponents)
        }
        func dateComponents(_ components: Set<Calendar.Component>, using calendar: Calendar = .current) -> DateComponents {
            calendar.dateComponents(components, from: self)
        }
        func startOfWeek(using calendar: Calendar = .current) -> Date {
            calendar.date(from: dateComponents([.yearForWeekOfYear, .weekOfYear], using: calendar))!
        }
        var noon: Date {
            Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
        }
        func daysOfWeek(using calendar: Calendar = .current) -> [Date] {
            let startOfWeek = self.startOfWeek(using: calendar).noon
            return (0...6).map { startOfWeek.byAdding(component: .day, value: $0, using: calendar)! }
        }
    }
    extension Formatter {
        static let ddMMyyyy: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .iso8601)
            dateFormatter.locale = .init(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter
        }()
    }
    extension Date {
        var ddMMyyyy: String { Formatter.ddMMyyyy.string(from: self) }
    }

    
    
    

