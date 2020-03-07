//
//  AppTheme.swift
//  Chat
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit
import DeviceKit


extension Density {
 
    static var isFrameless: Bool {
        let device = Device.current
        if device == .iPhoneX || device == .simulator(.iPhoneX)
            || device == .iPhoneXS || device == .simulator(.iPhoneXS)
            || device == .iPhoneXSMax || device == .simulator(.iPhoneXSMax)
            || device == .iPhoneXR || device == .simulator(.iPhoneXR)
            || device == .iPhone11 || device == .simulator(.iPhone11)
            || device == .iPhone11Pro || device == .simulator(.iPhone11Pro)
            || device == .iPhone11ProMax || device == .simulator(.iPhone11ProMax)
            || hasTopBottomNotch {
            return true
        }
        return false
    }
    
    static var hasTopBottomNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            let bottom = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 20
            //let top = UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
            return bottom// || top
        }
        return false
    }
}
