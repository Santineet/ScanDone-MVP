//
//  AppFont.swift
//  Project
//
//  Created by Igor Bizi, laptop2 on 01/08/2019.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

extension UIFont {
    
    static var delta : CGFloat {
        switch Density.value {
        case .group0, .group1:
            return 0.95
        case .group2:
            return 1.0
        case .group3:
            return 1.15
        case .group4:
            return 1.07
        case .group5:
            return 1.15
        case .pad1, .pad2, .pad3:
            return 1.3
        }
    }
}

extension RawRepresentable where RawValue == String {
    func font(size: Int, delta: CGFloat) -> UIFont? {
        return UIFont(name: rawValue, size: CGFloat(size) * delta)
    }
}

/// Lato
enum Lato: String {
    case regular = "Lato-Regular"
    case bold = "Lato-Bold"
    case medium = "Lato-Medium"
}

extension UIFont {
    static func _LatoRegular(_ size: Int) -> UIFont {
        return Lato.regular.font(size: size, delta: delta)!
    }
    static func _LatoBold(_ size: Int) -> UIFont {
        return Lato.bold.font(size: size, delta: delta)!
    }
    static func _LatoMedium(_ size: Int) -> UIFont {
        return Lato.medium.font(size: size, delta: delta)!
    }
}

/// Roboto
enum Roboto: String {
    case regular = "Roboto-Regular"
    case bold = "Roboto-Bold"
    case medium = "Roboto-Medium"
}

extension UIFont {
    static func _RobotoRegular(_ size: Int) -> UIFont {
        return Roboto.regular.font(size: size, delta: delta)!
    }
    static func _RobotoBold(_ size: Int) -> UIFont {
        return Roboto.bold.font(size: size, delta: delta)!
    }
    static func _RobotoMedium(_ size: Int) -> UIFont {
        return Roboto.medium.font(size: size, delta: delta)!
    }
}

/// TitilliumWeb

public enum TitilliumWeb: String {
    case semiBold = "TitilliumWeb-SemiBold"
    case regular = "TitilliumWeb-Regular"
}

extension UIFont {
    public static func _TitilliumWebRegular(_ size: Int) -> UIFont {
        return TitilliumWeb.regular.font(size: size, delta: delta)!
    }
    public static func _TitilliumWebSemiBold(_ size: Int) -> UIFont {
        return TitilliumWeb.semiBold.font(size: size, delta: delta)!
    }
}

/// UIFont.systemFont
extension UIFont {
    
    static func _light(_ size: Int) -> UIFont {
        return systemFont(ofSize: CGFloat(size) * self.delta, weight: .light)
    }
    
    static func _regular(_ size: Int) -> UIFont {
        return systemFont(ofSize: CGFloat(size) * self.delta, weight: .regular)
    }
    
    static func _medium(_ size: Int) -> UIFont {
        return systemFont(ofSize: CGFloat(size) * self.delta, weight: .medium)
    }
    
    static func _semibold(_ size: Int) -> UIFont {
        return systemFont(ofSize: CGFloat(size) * self.delta, weight: .semibold)
    }
    
    static func _bold(_ size: Int) -> UIFont {
        return systemFont(ofSize: CGFloat(size) * self.delta, weight: .bold)
    }
    
}
