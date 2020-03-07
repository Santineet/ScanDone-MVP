//
//  x.swift
//  Project
//
//  Created by Igor Bizi, laptop2 on 11/08/2019.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

class SystemVersion {

    static func equal(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedSame
    }
    
    static func greaterThan(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedDescending
    }
    
    static func greaterThanOrEqual(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedAscending
    }
    
    static func lessThan(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedAscending
    }
    
    static func lessThanOrEqual(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedDescending
    }
    
}
