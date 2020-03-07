//
//  String.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 8/19/16.
//  Copyright © 2016 BEST. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
//    func localized(arguments: CVarArg...) -> String {
//        return String.localizedStringWithFormat(NSLocalizedString(self, comment: ""), arguments)
//    }
}

//String.localizedStringWithFormat(NSLocalizedString("Translate%@your", comment: ""), "\n")

