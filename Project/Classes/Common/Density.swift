//
//  Density.swift
//  PhotoCompress
//
//  Created by Igor Bizi, laptop2 on 07/12/2018.
//  Copyright © 2018 MainasuK. All rights reserved.
//

import UIKit
import DeviceKit
 
enum Density {
    case group0, group1, group2, group3, group4, group5, pad1, pad2, pad3
    
    static var value : Density {
        let device = Device.current
        if device.isPod || device.isPhone {
            if device == .iPhone4 || device == .simulator(.iPhone4) || device == .iPhone4s || device == .simulator(.iPhone4s) || Device.allPods.contains(device) || Device.allSimulatorPods.contains(device) {
                return .group0
            } else if device == .iPhone5 || device == .simulator(.iPhone5) || device == .iPhone5s || device == .simulator(.iPhone5s) || device == .iPhoneSE || device == .simulator(.iPhoneSE) || device == .iPhone5c || device == .simulator(.iPhone5c) {
                return .group1
            } else if device == .iPhone6Plus || device == .simulator(.iPhone6Plus)
                || device == .iPhone6sPlus || device == .simulator(.iPhone6sPlus)
                || device == .iPhone7Plus || device == .simulator(.iPhone7Plus)
                || device == .iPhone8Plus || device == .simulator(.iPhone8Plus) {
                return .group3
            } else if device == .iPhone6 || device == .simulator(.iPhone6) || device == .iPhone6s || device == .simulator(.iPhone6s) || device == .iPhone7 || device == .simulator(.iPhone7) || device == .iPhone8 || device == .simulator(.iPhone8) {
                return .group2
            } else if device == .iPhoneXSMax || device == .simulator(.iPhoneXSMax)
                || device == .iPhoneXR || device == .simulator(.iPhoneXR)
                || device == .iPhone11 || device == .simulator(.iPhone11)
                || device == .iPhone11ProMax || device == .simulator(.iPhone11ProMax) {
                return .group5
            } else { // X Xs 11Pro
                return .group4
            }
        } else {
            if device == .iPadPro10Inch || device == .simulator(.iPadPro10Inch) {
                return .pad2
            } else if device == .iPadPro11Inch || device == .simulator(.iPadPro11Inch) || device == .iPadPro12Inch || device == .simulator(.iPadPro12Inch) || device == .iPadPro12Inch2 || device == .simulator(.iPadPro12Inch2) || device == .iPadPro12Inch3 || device == .simulator(.iPadPro12Inch3) {
                return .pad3
            } else {
                return .pad1
            }
        }
    }
    
    static var isPhone: Bool {
        let device = Device.current
        return device.isPod || device.isPhone
    }
    
    static var isPad: Bool {
        let device = Device.current
        return device.isPad
    }
}
