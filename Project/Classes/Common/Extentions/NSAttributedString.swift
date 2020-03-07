//
//  NSAttributedString.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 5/5/18.
//  Copyright © 2018 BEST. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    func numberOfLines(width: CGFloat) -> Int {
        
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)))
        let frameSetterRef : CTFramesetter = CTFramesetterCreateWithAttributedString(self as CFAttributedString)
        let frameRef: CTFrame = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), path.cgPath, nil)
        
        let linesNS: NSArray  = CTFrameGetLines(frameRef)
        
        guard let lines = linesNS as? [CTLine] else { return 0 }
        return lines.count
    }
    
    func update(_ attributes: [String : NSObject]) -> NSAttributedString {
        let range = (self.string as NSString).range(of: self.string)
        let attributed = NSMutableAttributedString(attributedString: self)
        attributed.setAttributes(convertToOptionalNSAttributedStringKeyDictionary(attributes), range: range)
        return attributed
    }
    
    static func line(width: CGFloat, title: String, text: String, newLine: Bool) -> NSAttributedString {
        let titleAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5), NSAttributedString.Key.font : UIFont._regular(15) ]
        let textAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont._regular(15) ]
        let spaceStr = NSAttributedString(string: "  ", attributes: titleAttributes)
        let newLineStr = NSAttributedString(string: "\n", attributes: titleAttributes)
        let dotsStr = NSAttributedString(string: "...", attributes: textAttributes)
        
        let string = NSMutableAttributedString()
        
        if newLine {
            string.append(newLineStr)
        }
        
        let titleStr = NSAttributedString(string: title, attributes: titleAttributes)
        let textStr = NSAttributedString(string: text, attributes: textAttributes)
        string.append(titleStr)
        string.append(spaceStr)
        string.append(textStr)
        
        func deleteLastChar() {
            guard string.length > 0 else {
                return
            }
            string.deleteCharacters(in: NSRange(location: string.length-1, length: 1))
        }
        
        var didSelectDeleteChars = false
        let max = newLine ? 2 : 1
        while string.numberOfLines(width: width) > max {
            deleteLastChar()
            didSelectDeleteChars = true
        }
        
        if didSelectDeleteChars {
            deleteLastChar()
            deleteLastChar()
            deleteLastChar()
            string.append(dotsStr)
        }
        
        return string
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
 
