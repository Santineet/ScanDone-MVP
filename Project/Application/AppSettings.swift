//
//  A.swift
//  Project
//
//  Created by Igor Bizi, laptop2 on 03/01/2019.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

class AppSettings {

    private static let kUIdKey = "AppSettings-kUIdKey"
    static var uId: String? {
        get {
            return UserDefaults.standard.value(forKey: kUIdKey) as? String ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kUIdKey)
        }
    }
    
    private static let kUGeoKey = "AppSettings-kUGeoKey"
    static var uGeo: String {
        get {
            return UserDefaults.standard.value(forKey: kUGeoKey) as? String ?? Locale.current.regionCode ?? "?"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kUGeoKey)
        }
    }
    
    private static let kDidRegisterKey = "AppSettings-kDidRegisterKey"
    static var didRegister: Bool {
        get {
            if App.alwaysRegister {
                return false
            }
            return UserDefaults.standard.bool(forKey: kDidRegisterKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kDidRegisterKey)
        }
    }
    
    private static let kShouldReviewAppKey = "AppSettings-kShouldReviewAppKey"
    static var shouldReviewApp: Bool {
        get {
            return UserDefaults.standard.bool(forKey: kShouldReviewAppKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kShouldReviewAppKey)
        }
    }
}
