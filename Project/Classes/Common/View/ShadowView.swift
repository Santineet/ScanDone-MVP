//
//  NoContentView.swift
//  BreatheTrainer
//
//  Created by IgorBizi@mail.ru on 8/13/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit


class ShadowView: UIView {
    
    var cornerRadius: CGFloat? {
        didSet {
            reload()
        }
    }
    
    var color: UIColor = UIColor.black.withAlphaComponent(0.1) {
        didSet {
            shadowLayer.shadowColor = color.cgColor
        }
    }
    
    var shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0) {
        didSet {
            shadowLayer.shadowOffset = shadowOffset
        }
    }
    
    var shadowOpacity: Float = 1  {
        didSet {
            shadowLayer.shadowOpacity = shadowOpacity
        }
    }
    
    var blur: CGFloat = 8 {
        didSet {
            shadowLayer.shadowRadius = blur / 2.0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        
    }
    
    func setup() {
        backgroundColor = .clear
        
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOffset = shadowOffset
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = blur / 2.0
        shadowLayer.fillColor = UIColor.clear.cgColor
    }
    
    lazy var shadowLayer: CAShapeLayer = {
        var shadowLayer = CAShapeLayer()
        self.layer.insertSublayer(shadowLayer, at: 0)
        return shadowLayer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius ?? bounds.height / 2).cgPath
        shadowLayer.shadowPath = shadowLayer.path
    }

}



