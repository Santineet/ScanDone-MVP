//
//  UIImageViewExtensions.swift
//  Project
//
//  Created by Shane Gao on 2019/8/8.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public func rotate(to rotatedImage: UIImage?, complete: (() -> Void)?) {
        guard let image = image, let superview = superview else { return }
        
        let copied = UIImageView(image: image)
        copied.frame.size = image.size.scaled(by: frame.size)
        copied.center = center
        superview.addSubview(copied)
        
        self.image = nil
        
        let targetSize = image.size.scaled(by: frame.size.reverse)
        UIView.animate(
            withDuration: 0.25,
            animations: { [weak self] in
                guard let center = self?.center else { return }
                copied.frame.size = targetSize
                copied.center = center
                copied.transform = CGAffineTransform(rotationAngle: -.pi * 0.5)
            },
            completion: { [weak self] finished in
                if finished {
                    self?.image = rotatedImage
                    copied.removeFromSuperview()
                    complete?()
                }
            }
        )
    }
}
