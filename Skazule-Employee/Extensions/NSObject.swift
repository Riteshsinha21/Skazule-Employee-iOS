//
//  NSObject.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/14/23.
//

import Foundation


extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
    
}
