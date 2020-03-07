//
//  Double+NumberFormatter.swift
//  BreatheTrainer
//
//  Created by IgorBizi@mail.ru on 8/2/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import Foundation

extension Double {
    
    static let numberFormatter: NumberFormatter = {
        let instance = NumberFormatter()
        instance.numberStyle = .decimal
        return instance
    }()
    
    func toSecString() -> String {
        let number = NSNumber.init(value: self)
        return Double.numberFormatter.string(from: number)! + " sec"
    }
    
    func toMinString() -> String {
        let number = NSNumber.init(value: self)
        return Double.numberFormatter.string(from: number)! + " min"
    }
    
    func round(_ to: Int) -> String {
        return String(format: "%.\(to)f", self)
    }

}
