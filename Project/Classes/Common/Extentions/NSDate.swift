//
//  NSDate+dataString.swift
//  FunnyFeed
//
//  Created by IgorBizi@mail.ru on 7/18/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import Foundation

extension Date
{
    
    init(dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
        let d = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:d)
    }
    
    
}

//Weekday
extension Date {
    func dayOfTheWeek() -> String? {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Satudrday,"
        ]
        
        let calendar: Calendar = Calendar.current
        let components: DateComponents = (calendar as NSCalendar).components(.weekday, from: self)
        return weekdays[components.weekday! - 1]
    }
}

// NSDate+components
extension Date {
    
    static func randomDate(daysBack: Int)-> NSDate {
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        var value = Int(day - 1)
        if value < 2 {
            value = 2
        }
        offsetComponents.day = -value   
        offsetComponents.hour = Int(hour)
        offsetComponents.minute = Int(minute)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0))!
        return randomDate! as NSDate
    }
    
    static func from(_ year: Int, weekOfYear: Int) -> Date {
        var c = DateComponents()
        c.year = year
        c.weekOfYear = weekOfYear
        return Calendar.current.date(from: c)!
    }
    
    static func from(_ year: Int, month: Int, weekOfYear: Int, day: Int) -> Date {
        var c = DateComponents()
        c.year = year
        c.month = month
        c.day = day
        c.weekOfYear = weekOfYear
   
        return Calendar.current.date(from: c)!
    }
    
    static func from(_ year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var c = DateComponents()
        c.year = year
        c.month = month
        c.day = day
        c.hour = hour
        c.minute = minute
        c.second = 0
        return Calendar.current.date(from: c)!
    }
    
    func components() -> DateComponents {
        return components(timeZone: nil)
    }
    
    func components(timeZone: TimeZone?) -> DateComponents {
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekday, .weekOfYear, .month, .year]
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        return (calendar as NSCalendar).components(unitFlags, from: self)
    }
    
    func generateDates(_ calendarUnit: NSCalendar.Unit, startDate: Date, endDate: Date) -> [Date] {
        
        let calendar = Calendar.current
        let normalizedStartDate = calendar.startOfDay(for: startDate)
        let normalizedEndDate = calendar.startOfDay(for: endDate)
        
        var dates = [normalizedStartDate]
        var currentDate = normalizedStartDate
        
        guard normalizedStartDate.compare(normalizedEndDate) == .orderedAscending else {
            return dates
        }
        
        repeat {
            currentDate = (calendar as NSCalendar).date(byAdding: calendarUnit, value: 1, to: currentDate, options: NSCalendar.Options.matchNextTime)!
            dates.append(currentDate)
            
            if dates.count > 10000 {
                return dates
            }
        } while !calendar.isDate(currentDate, inSameDayAs: normalizedEndDate)
        
        return dates
    }
    
    func lastDayOfMonth() -> Date {
        let calendar = Calendar.current
        let dayRange = (calendar as NSCalendar).range(of: .day, in: .month, for: self)
        let dayCount = dayRange.length
        var comp = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        comp.day = dayCount
        return calendar.date(from: comp)!
    }
    
    func firstDayOfMonth() -> Date {
        let calendar = Calendar.current
        var comp = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        comp.day = 1
        return calendar.date(from: comp)!
    }
    
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self) == self.compare(date2)
    }
    
    //1d 15h, 53min, 1h 24m
    func offsetFrom(date: Date) -> String {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.second, .day, .hour, .minute]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);
        
        let secondsValue = difference.second ?? 0
        let minutesValue = difference.minute ?? 0
        let hoursValue = difference.hour ?? 0
        let daysValue = difference.day ?? 0
        
        var seconds = ""
        if secondsValue >= 0 {
            seconds = "\(secondsValue)sec"
        }
        var minutes = ""
        if minutesValue > 0 {
            minutes = "\(minutesValue)min"
        }
        var hours = ""
        if hoursValue > 0 {
            hours = "\(hoursValue)h"
            if !minutes.isEmpty {
                hours += " " + minutes
            }
        }
        var days = ""
        if daysValue > 0 {
            days = "\(daysValue)d"
            if !hours.isEmpty {
                days += " " + hours
            }
        }
        
        if let day = difference.day, day > 0 {
            return days
        }
        if let hour = difference.hour, hour > 0 {
            return hours
        }
        if let minute = difference.minute, minute > 0 {
            return minutes
        }
        if let second = difference.second, second >= 0 {
            return seconds
        }
        return ""
    }
}


extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
