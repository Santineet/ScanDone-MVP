//
//  NetworkManager.swift
//  MusicPlayer
//
//  Created by IgorBizi@mail.ru on 4/15/18.
//  Copyright © 2018 IgorBizi@mail.ru. All rights reserved.
//

import Foundation

extension NetworkManager {
    
    static let domain = "https://\(App.domain)/"

    static func parameters() -> [String: Any] {
        guard AppSettings.uId != nil else {
            return [String: Any]()
        }
        let result: [String : Any] = ["uid" : AppSettings.uId ?? "?"]
        return result
    }
}

