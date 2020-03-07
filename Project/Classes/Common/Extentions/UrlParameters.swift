//
//  UrlParameters.swift
//  MusicPlayer
//
//  Created by IgorBizi@mail.ru on 8/17/17.
//  Copyright © 2017 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

extension String {
    
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Returns percent-escaped string.
    
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
}

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            var keyStr: String = ""
            if let key = key as? String {
                keyStr = key
            } else {
                keyStr = String(describing: key)
            }
            let percentEscapedKey = keyStr.stringByAddingPercentEncodingForURLQueryValue()!
            
            var valueStr: String = ""
            if let value = value as? String {
                valueStr = value
            } else {
                valueStr = String(describing: value)
            }
            let percentEscapedValue = valueStr.stringByAddingPercentEncodingForURLQueryValue()!
            
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
}

extension URL {
    static func byAddingParameters(_ url: URL, parameters: [String : Any]) -> URL {
        return URL(string:"\(url.absoluteString)?\(parameters.stringFromHttpParameters())")!
    }
}
