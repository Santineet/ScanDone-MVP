//
//  NetworkManager.swift
//  MusicPlayer
//
//  Created by IgorBizi@mail.ru on 4/15/18.
//  Copyright © 2018 IgorBizi@mail.ru. All rights reserved.
//

import Foundation


class NetworkManager: NSObject {
    
    var sessionManager: SessionManager?
    
    static let shared: NetworkManager = {
        let instance = NetworkManager()
        
        return instance
    }()
    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionManager = SessionManager(configuration: configuration)
    }
}
