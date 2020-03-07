//
//  String.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 8/19/16.
//  Copyright © 2016 BEST. All rights reserved.
//

import UIKit

extension String {
    var url: URL? {
        if self != "" && !isEmpty {
            return URL(string: self)
        } else {
            return nil
        }
    }
    
    func encodeUrl() -> String
    {
//        return (self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! as NSString).replacingOccurrences(of: "%", with: "")

        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
    }
    func decodeUrl() -> String
    {
        return self.removingPercentEncoding!
    }
    
    var urlFromPath: URL? {
        if self != "" {
            return URL(fileURLWithPath: self)
        } else {
            return nil
        }
    }
    
    var capitalizedFirstCharacter: String? {
        guard !self.isEmpty else {
            return ""
        }
        return String(prefix(1)).uppercased() + String(dropFirst())
    }
    
    static func stringWithValue(value: Int, one: String, many: String) -> String {
        return String(value) + " " + stringFromValue(value: value, one: one, many: many)
    }
    
    static func stringFromValue(value: Int, one: String, many: String) -> String {
        if value == 1 {
            return one
        } else {
            return many
        }
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: ([(NSAttributedString.Key.font): font]), context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: ([(NSAttributedString.Key.font): font]), context: nil)
        
        return ceil(boundingBox.width)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
