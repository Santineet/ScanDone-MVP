//
//  RoundView.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 1/8/17.
//  Copyright © 2017 BEST. All rights reserved.
//

import Foundation

class RoundLabel: UILabel {
    
    var cornerRadius: CGFloat? {
        didSet {
            reload()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBounds()
    }
    
    func layoutBounds() {
        layer.cornerRadius = cornerRadius ?? bounds.height / 2
        layer.masksToBounds = true
    }
}
