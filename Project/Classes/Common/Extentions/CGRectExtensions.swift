//
//  CGRectExtensions.swift
//  Project
//
//  Created by Shane Gao on 2019/8/5.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import CoreGraphics

extension CGRect {
    
    public static func with(origin: CGPoint = .zero, size: CGSize = .zero) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    
    public static func with(x: CGFloat = 0.0, y: CGFloat = 0.0, width: CGFloat = 0.0, height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
}
