//
//  UILabel.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 4/25/17.
//  Copyright © 2017 BEST. All rights reserved.
//

import UIKit

extension UILabel {
    
    func addShadowText(_ alpha: CGFloat) {
        shadowColor = UIColor.black.withAlphaComponent(alpha)
        shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func addShadowTextLight() {
        shadowColor = UIColor.black.withAlphaComponent(0.11)
        shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func addShadowTextMeduim() {
        shadowColor = UIColor.black
        shadowOffset = CGSize(width: 1, height: 1)
    }
    
//    override func removeShadow() {
//        shadowColor = UIColor.clear
//        shadowOffset = CGSize(width: 0, height: 0)
//    }
}
