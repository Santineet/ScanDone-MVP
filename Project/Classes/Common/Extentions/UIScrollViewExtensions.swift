//
//  UIScrollViewExtensions.swift
//  Project
//
//  Created by Shane Gao on 2019/8/17.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    public func reachRight(offset: CGFloat = 0.0) -> Bool {
        let width = frame.size.width
        let visibleWidth = width - contentInset.left - contentInset.right
        let x = contentOffset.x + contentInset.left
        return x > max(0, contentSize.width - visibleWidth) + offset
    }
}
