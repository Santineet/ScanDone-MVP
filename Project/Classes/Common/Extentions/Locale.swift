//
//  Locale.swift
//  Project
//
//  Created by Igor Bizi, laptop2 on 11/08/2019.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

extension Locale {

    static var languageCodeString: String {
        return (Locale.current.languageCode ?? "") + "-" + (Locale.current.scriptCode ?? "")
    }

    static var item: LocaleItem {
        return LocaleItem.init(rawValue: languageCodeString) ?? .English
    }
}

enum LocaleItem: String {
    case ChineseSimplified = "zh-Hans", ChineseTraditional = "zh-Hant", English
}
