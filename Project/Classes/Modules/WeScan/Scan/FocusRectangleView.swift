//
//  FocusRectangleView.swift
//  WeScan
//
//  Created by Julian Schiavo on 16/11/2018.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

/// A yellow rectangle used to display the last 'tap to focus' point
final class FocusRectangleView: RoundView {
    convenience init(touchPoint: CGPoint) {
        let originalSize: CGFloat = 200
        let finalSize: CGFloat = 80
        
        // Here, we create the frame to be the `originalSize`, with it's center being the `touchPoint`.
        self.init(frame: CGRect(x: touchPoint.x - (originalSize / 2), y: touchPoint.y - (originalSize / 2), width: originalSize, height: originalSize))
        
        backgroundColor = .clear
        layer.borderWidth = 1.0
        //layer.cornerRadius = 6.0
        layer.borderColor = UIColor.white.alpha(0.9).cgColor
        
        // Here, we animate the rectangle from the `originalSize` to the `finalSize` by calculating the difference.
        weak var weakSelf = self
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.frame.origin.x += (originalSize - finalSize) / 2
            self.frame.origin.y += (originalSize - finalSize) / 2
            
            self.frame.size.width -= (originalSize - finalSize)
            self.frame.size.height -= (originalSize - finalSize)
        }, completion: { (done) in
            UIView.animate(withDuration: 0.7, delay: 0.7, animations: {
                weakSelf?.alpha = 0.0
            }, completion: { (_) in
                weakSelf?.removeFromSuperview()
            })
        })
    }
    
}
