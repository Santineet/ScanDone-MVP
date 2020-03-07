//
//  FilePathConvertible.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 7/23/16.
//
//

import Foundation

public protocol FilePathConvertible {
    var urlFromPath1: URL { get }
    var path: String { get }
}

extension FilePathConvertible {
    var isEmptyPath: Bool {
        return path.isEmpty
    }
}

extension String: FilePathConvertible {
    public var urlFromPath1: URL {
        return URL(fileURLWithPath: self)
    }
    
    public var path: String {
        return self
    }
}

extension URL: FilePathConvertible {
    public var urlFromPath1: URL {
        return self
    }
}
