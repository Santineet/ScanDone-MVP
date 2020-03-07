//
//  SubscriptionButton.swift
//  VPN01
//
//  Created by Igor Bizi, laptop2 on 23/10/2018.
//  Copyright © 2018 Igor Bizi. All rights reserved.
//

import UIKit

class SubscriptionButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor.white, for: UIControl.State())
        titleLabel?.font = UIFont._LatoMedium(14)
        backgroundColor = .clear
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        layer.cornerRadius = 10
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
//    }
    
//    override open var intrinsicContentSize: CGSize {
//        let intrinsicContentSize = super.intrinsicContentSize
//        return CGSize(width: intrinsicContentSize.width, height: intrinsicContentSize.height + 10)
//    }
}
