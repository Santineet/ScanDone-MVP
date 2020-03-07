//
//  UIButtonExtensions.swift
//  Project
//
//  Created by Shane Gao on 2019/8/5.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

extension UIButton {
    
    func reverseTitleImage(_ reversed: Bool = true) {
        transform = CGAffineTransform(scaleX: reversed ? -1.0 : 1.0, y: 1.0)
        titleLabel?.transform = CGAffineTransform(scaleX: reversed ? -1.0 : 1.0, y: 1.0)
        imageView?.transform = CGAffineTransform(scaleX: reversed ? -1.0 : 1.0, y: 1.0)
    }
    
    func horizontal(spacing: CGFloat, reversed: Bool = false) {
        let edgeOffset = spacing / 2
        if reversed {
            guard let imageSize = self.imageView?.image?.size,
                let text = self.titleLabel?.text,
                let font = self.titleLabel?.font else { return }
            
            let labelString = NSString(string: text)
            let titleSize = labelString.size(withAttributes: [.font: font])
            imageEdgeInsets = UIEdgeInsets(
                top: 0, left: titleSize.width + edgeOffset, bottom: 0, right: -titleSize.width - edgeOffset
            )
            titleEdgeInsets = UIEdgeInsets(
                top: 0, left: -imageSize.width - edgeOffset, bottom: 0, right: imageSize.width + edgeOffset
            )
        } else {
            imageEdgeInsets = UIEdgeInsets(
                top: 0, left: -edgeOffset, bottom: 0, right: edgeOffset
            )
            titleEdgeInsets = UIEdgeInsets(
                top: 0, left: edgeOffset, bottom: 0, right: -edgeOffset
            )
        }

        // increase content width to avoid clipping
        contentEdgeInsets = UIEdgeInsets(top: 0, left: edgeOffset, bottom: 0, right: edgeOffset)
    }
    
    @discardableResult
    func imageTitle(spacing: CGFloat) -> UIButton {
        let half: CGFloat = spacing * 0.5
        imageEdgeInsets = .init(top: 0.0, left: 0.0, bottom: 0.0, right: half)
        titleEdgeInsets = .init(top: 0.0, left: half, bottom: 0.0, right: 0.0)
        return self
    }
    
    public func tap(_ target: Any?, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    public func title(_ val: String?) {
        setTitle(val, for: .normal)
    }
}
