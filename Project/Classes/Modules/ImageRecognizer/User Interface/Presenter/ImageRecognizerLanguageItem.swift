//
//  ImageRecognizerLanguage.swift
//  Project
//
//  Created by Igor Bizi, laptop2 on 10/10/2019.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit
import SwiftyTesseract

enum ImageRecognizerLanguageItem: String {
    case ChineseSimplified
    case ChineseTraditional
    case English
    
    static var allValues: [ImageRecognizerLanguageItem] = [.English, .ChineseTraditional, .ChineseSimplified]

    var title: String {
        switch self {
        case .ChineseSimplified: return "Chinese Simplified".localized.uppercased()
        case .ChineseTraditional: return "Chinese Traditional".localized.uppercased()
        case .English: return "English".localized.uppercased()
        }
    }
    
    var recognitionLanguage: RecognitionLanguage {
        switch self {
        case .ChineseSimplified: return .chineseSimplified
        case .ChineseTraditional: return .chineseTraditional
        case .English: return .english
        }
    }
    
    private static let kSelectedKey = "ImageRecognizerLanguageItem-kSelectedKey"
    static var selected: ImageRecognizerLanguageItem {
        get {
            if let rawValue = UserDefaults.standard.value(forKey: kSelectedKey) as? String, let item = ImageRecognizerLanguageItem.init(rawValue: rawValue) {
                return item
            }
            
            switch Locale.item {
            case .ChineseSimplified: return .ChineseSimplified
            case .ChineseTraditional: return .ChineseTraditional
            default: return English
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: kSelectedKey)
        }
    }
}
