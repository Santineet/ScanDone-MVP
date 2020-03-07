//
//  PageControl.swift
//  VPN01
//
//  Created by Shane Gao on 2019/8/14.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

class PageControl: UIPageControl {
    
    public var itemSize = CGSize(width: 8, height: 8) {
        didSet {
            layoutIfNeeded()
        }
    }
    
    /// space of two indicator
    public var indicatorSpacing: CGFloat = 20.0 {
        didSet {
            layoutIfNeeded()
        }
    }
}

extension PageControl {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if subviews.count > 0 {
            let y = subviews.first!.frame.origin.y
            let needSize = size(forNumberOfPages: numberOfPages)
            var startX = (self.frame.width - needSize.width) * 0.5
            for index in 0..<subviews.count {
                let view = subviews[index]
                view.layer.cornerRadius = min(itemSize.width, itemSize.height) * 0.5
                view.frame = CGRect(origin: CGPoint(x: startX, y: y), size: itemSize)
                startX += (itemSize.width + indicatorSpacing)
            }
        }
    }
    
    public override func size(forNumberOfPages pageCount: Int) -> CGSize {
        if pageCount > 0 {
            let width = CGFloat(pageCount) * itemSize.width + CGFloat(pageCount - 1) * indicatorSpacing
            return CGSize(width: width, height: itemSize.height)
        }
        return super.size(forNumberOfPages: pageCount)
    }
    
}

