//
//  UIImage.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 7/21/23.
//

import Foundation
import UIKit

extension UIImage{
    func imageWithSize(scaledToSize newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
