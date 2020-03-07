//
//  SettingOption.swift
//  Project
//
//  Created by Shane Gao on 2019/8/21.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import Foundation

enum SettingOption: CaseIterable {
    case subscription, contacts, terms, privacy, clearCache
    
    var name: String {
        switch self {
        case .subscription:
            return "Subscription".localized.uppercased()
        case .contacts:
            return "Contacts".localized.uppercased()
        case .terms:
            return "Terms of service".localized.uppercased()
        case .privacy:
            return "Privacy policy".localized.uppercased()
        case .clearCache:
            return "Clear cache".localized.uppercased()
        }
    }
}

extension SettingOption {
    var color: UIColor {
        switch self {
        case .clearCache:
            return UIColor.hexColor("188834")
        default:
            return UIColor.hexColor("040F0F")
        }
    }
}
