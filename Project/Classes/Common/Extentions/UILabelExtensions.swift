//
//  UILabelExtensions.swift
//  Project
//
//  Created by Shane Gao on 2019/8/2.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

extension UILabel {
    @discardableResult
    public func align(_ val: NSTextAlignment) -> UILabel {
        textAlignment = val
        return self
    }
    
    @discardableResult
    public func font(_ val: UIFont) -> UILabel {
        font = val
        return self
    }
    
    @discardableResult
    public func textColor(_ val: UIColor) -> UILabel {
        textColor = val
        return self
    }
    
    @discardableResult
    public func text(_ val: String?) -> UILabel {
        text = val
        return self
    }
}
