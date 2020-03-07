//
//  NSPredicate.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 4/22/17.
//  Copyright © 2017 BEST. All rights reserved.
//

import Foundation


extension NSPredicate {
    
    static func predicateForDayFromDate(_ date: Date, dateField: String) -> NSPredicate {
        let calendar = Calendar.current //(identifier: NSCalendarIdentifierGregorian)!
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekday, .weekOfYear, .month, .year]
        var components = (calendar as NSCalendar).components(unitFlags, from: date)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar.date(from: components)!
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)!
        return NSPredicate(format: "\(dateField) >= %@ AND \(dateField) =< %@", argumentArray: [startDate, endDate])
    }
}
