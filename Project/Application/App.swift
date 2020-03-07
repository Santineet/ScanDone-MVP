//
//  App.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 11/23/17.
//  Copyright © 2017 BEST. All rights reserved.
//

import Foundation

class App {
    static let enableAnalytics =                            Bool(truncating: 1) //release 1
    
    static var unlockPremium =                              Bool(truncating: 0) //release 0
    static let unlockPremiumAfterClosePurchaseScreen =      Bool(truncating: 0) //release 0
    static var skipLaunchImage =                            Bool(truncating: 0) //release 0
    static var skipOnboarding =                             Bool(truncating: 0) //release 0
    static let alwaysShowOnboarding =                       Bool(truncating: 0) //release 0
    static let showPremiumOnStart =                         Bool(truncating: 0) //release 0
    static let showTestDocuments =                          Bool(truncating: 0) //release 0

    static let alwaysRegister =                             Bool(truncating: 0) //release 0
    static let enableTestScan =                             Bool(truncating: 0) //release 0
    static let enableScanDidBuy =                           Bool(truncating: 0) //release 0

    static let name = "SCANDONE"
    static let contactEmail = "support@scan-done.com"
    static let domain = "scan-done.com"
    static var privacyUrlString: String {
        switch Locale.item {
        case .ChineseSimplified: return "https://scan-done.com/data-policy-CN-s.html"
        case .ChineseTraditional: return "https://scan-done.com/data-policy-CN-t.html"
        default: return "https://scan-done.com/data-policy.html"
        }
    }
    static var termsUrlString: String {
        switch Locale.item {
        case .ChineseSimplified: return "https://scan-done.com/terms-of-use-CN-s.html"
        case .ChineseTraditional: return "https://scan-done.com/terms-of-use-CN-t.html"
        default: return "https://scan-done.com/terms-of-use.html"
        }
    }
    
    static let statusPurchaseOn = true
}
