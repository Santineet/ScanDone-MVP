//
//  GradientView.swift
//  JOCircularSlider_Example
//
//  Created by Jalal Ouraigua on 05/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

enum GradientDirection {
    case topToBottom, leftToRight
}

@IBDesignable
class BZGradientView: UIView {

    var direction = GradientDirection.topToBottom { didSet { setNeedsDisplay() }}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        backgroundColor = .clear

    }
    
    @IBInspectable
    var color1: UIColor = UIColor(red: 0, green: 1, blue: 0.76, alpha: 1) { didSet { setNeedsDisplay() }}

    @IBInspectable
    var color2: UIColor = UIColor(red: 0, green: 0.82, blue: 1, alpha: 1) { didSet { setNeedsDisplay() }}

    override func draw(_ rect: CGRect) {

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = [color1.cgColor, color2.cgColor]
        let locations: [CGFloat] = [0.0, 1.0]

        let context = UIGraphicsGetCurrentContext()!

        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors  as CFArray, locations: locations) else { return }

        switch direction {
        case .topToBottom:
            context.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: 0, y: bounds.height), options: CGGradientDrawingOptions(rawValue: 0))
        case .leftToRight:
            context.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: bounds.width, y: 0), options: CGGradientDrawingOptions(rawValue: 0))
        }
    }
}
