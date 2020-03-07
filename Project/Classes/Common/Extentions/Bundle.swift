//
//  Bundle.swift
//  MusicPlayer
//
//  Created by IgorBizi@mail.ru on 8/1/17.
//  Copyright © 2017 IgorBizi@mail.ru. All rights reserved.
//

import Foundation

extension Bundle {
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
    }
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "?"
    }
}
