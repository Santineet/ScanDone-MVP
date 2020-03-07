//
//  String.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 8/19/16.
//  Copyright © 2016 BEST. All rights reserved.
//

import Foundation

extension String {
    
    static func createIdFromTodayDate() -> String {
        return createIdFromDate(date: Date())
    }
    
    static func createIdFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmssSSSS"
        return formatter.string(from: date)
    }
    
}
