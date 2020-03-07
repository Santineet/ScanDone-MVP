//
//  AppTheme.swift
//  Chat
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

extension UIColor {
    
    func alpha(_ val: CGFloat) -> UIColor {
        return withAlphaComponent(val)
    }
    
    static var random: UIColor {
        let red = CGFloat(arc4random_uniform(255)) / 255.0
        let green = CGFloat(arc4random_uniform(255)) / 255.0
        let blue = CGFloat(arc4random_uniform(255)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    public static func linearGradient(start: UIColor, end: UIColor, size: CGSize) -> UIColor? {
        guard let gradient = UIImage.linearGradient(start: start, end: end, size: size)
        else { return nil }
        return UIColor(patternImage: gradient)
    }
    
    public static func color(withGradientLayer layer:CAGradientLayer, size: CGSize) -> UIColor? {
        guard let gradient = UIImage.image(withGradientLayer: layer, size: size)
            else { return nil }
        return UIColor(patternImage: gradient)
    }
}

extension UIColor {
    /// Gray
    static let _gray1: UIColor = .init(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
    static let _gray2: UIColor = hexColor("A1A1A1")
    static let _gray3: UIColor = hexColor("252525")
    static let _gray4: UIColor = hexColor("1C272D")
    static let _gray5: UIColor = hexColor("222222")
    static let _gray6: UIColor = hexColor("FBFBFB")
    static let _gray7: UIColor = hexColor("E5E5E5")
    
    /// Red
    static let _redBg: UIColor = hexColor("4D0200")
    static let _green1: UIColor = UIColor(red: 0.273, green: 0.762, blue: 0.395, alpha: 1)
    static func _greenGradient(with size: CGSize) -> UIColor? {
        return linearGradient(start: ._green1, end: ._green1, size: size)
    }
    
    static let _blue1: UIColor = hexColor("#46C265")
    static let _blue2: UIColor = hexColor("0066FF")
        
    static let _pink1: UIColor = hexColor("007AFF")
    
    static let _black1: UIColor = hexColor("4D0200")
    static let _black2: UIColor = hexColor("444444")
    
    static let _pink2: UIColor = hexColor("FF0087")
    
    static let _green2: UIColor = hexColor("46C265")
    static let _green3: UIColor = UIColor(red: 0.093, green: 0.533, blue: 0.202, alpha: 1)

    static let _light1: UIColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)

}

/// hex <-> UIColor
extension UIColor {
    static func hexColor(_ hex: String) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        guard cString.count == 6 else { return .gray }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format:"%06x", rgb)
    }
}
