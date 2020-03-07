//
//  EditScanCornerView.swift
//  WeScan
//
//  Created by Boris Emorine on 3/5/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

/// A UIView used by corners of a quadrilateral that is aware of its position.
final class EditScanCornerView: UIView {
    
    let position: CornerPosition
    
    /// The image to display when the corner view is highlighted.
    private var image: UIImage?
    private(set) var isHighlighted = false
    private(set) var fillBackgroundColorWithReset = true
    
    var fillColor = UIColor.white.cgColor

    lazy private var circleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = fillColor
        layer.lineWidth = 0.0
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 5)
        return layer
    }()
    
    init(frame: CGRect, position: CornerPosition) {
        self.position = position
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        clipsToBounds = true
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2.0
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let bezierPath = UIBezierPath(ovalIn: rect.insetBy(dx: circleLayer.lineWidth, dy: circleLayer.lineWidth))
        circleLayer.frame = rect
        circleLayer.path = bezierPath.cgPath
        
        image?.draw(in: rect)
    }
    
    func highlightWithImage(_ image: UIImage) {
        isHighlighted = true
        self.image = image
        circleLayer.fillColor = UIColor.clear.cgColor
        self.setNeedsDisplay()
    }
    
    func reset() {
        isHighlighted = false
        image = nil
        circleLayer.fillColor = fillColor
        setNeedsDisplay()
    }
    
}
