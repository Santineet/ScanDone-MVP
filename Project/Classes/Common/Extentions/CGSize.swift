//
//  Int.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 2/24/17.
//  Copyright © 2017 BEST. All rights reserved.
//

import Foundation
 
extension CGSize {
    func isGreaterOrEqual(to size: CGSize) -> Bool {
        return width >= size.width &&
            height >= size.height
    }
    
    func isEqual(to size: CGSize) -> Bool {
        return width == size.width &&
            height == size.height
    }
}

extension CGSize {
    public static func constant(_ val: CGFloat) -> CGSize {
        return CGSize(width: val, height: val)
    }
    
    public static func constant(_ val: Int) -> CGSize {
        return CGSize(width: val, height: val)
    }
    
    public static func constant(_ val: Double) -> CGSize {
        return CGSize(width: val, height: val)
    }
}

extension CGSize {
    
    public var reverse: CGSize {
        return .init(width: height, height: width)
    }
    
    public func scaled(by size: CGSize) -> CGSize {
        let aspet = width / height, byAspet = size.width / size.height
        if aspet > byAspet {
            return .init(
                width: size.width,
                height: size.width / width * height
            )
        } else {
            return .init(
                width: size.height * width / height,
                height: size.height
            )
        }
    }
    
}
