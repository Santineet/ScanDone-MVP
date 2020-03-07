//
//  Enum+Iterate.swift
//  100500
//
//  Created by IgorBizi@mail.ru on 6/18/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import Foundation

class Enum {
    static func iterate<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        return AnyIterator {
            let next = withUnsafePointer(to: &i) {
                UnsafeRawPointer($0).load(as: T.self)
            }
            if next.hashValue == i {
                i += 1
                return next
            } else {
                return nil
            }
        }
    }
}
