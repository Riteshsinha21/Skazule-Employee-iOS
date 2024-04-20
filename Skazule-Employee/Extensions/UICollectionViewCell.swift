//
//  UICollectionViewCell.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 9/25/23.
//

import Foundation
import UIKit

extension UICollectionViewCell{

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

}
