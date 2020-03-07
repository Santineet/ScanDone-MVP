//
//  UIView.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 11/24/16.
//  Copyright © 2016 BEST. All rights reserved.
//

import Foundation


extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){
        
        self.init()
        
        let path = CGMutablePath()
        
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        
        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
            path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }
        
        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }
        
        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }
        
        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        path.closeSubpath()
        cgPath = path
    }
}

extension UIView {
    
    func reload(_ animated: Bool = false) {
        func apply() {
            setNeedsLayout()
            layoutIfNeeded()
        }
        if animated {
            UIView.animate(withDuration: 0.5) {
                apply()
            }
        } else {
            apply()
        }
    }
    
    func addShadow(color: UIColor = UIColor.darkGray, offset: CGSize = CGSize(width: 0, height: 1), radius: CGFloat = 2, opacity: CGFloat = 0.8) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.8
    }
    
    func addShadowLikeNav() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
    }
    
    func addShadowHard() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
    }
    
    func addShadow2() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.5
    }
    
    func removeShadow() {
        layer.shadowColor = nil
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0
    }
    
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    @discardableResult func roundCorners(_ corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let name = " addBorder(mask: CAShapeLayer, borderColor"
        for i in layer.sublayers ?? [] {
            if i.name == name {
                i.removeFromSuperlayer()
            }
        }
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        borderLayer.name = name
        layer.addSublayer(borderLayer)
    }
    
    func roundCorners(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func heightToFit(_ width: CGFloat) -> CGFloat {
        var rect = frame
        rect.size.width = width
        frame = rect
        
        setNeedsLayout()
        layoutIfNeeded()
        return systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }
    
    func widthToFit(_ height: CGFloat) -> CGFloat {
        var rect = frame
        rect.size.height = height
        frame = rect
        
        setNeedsLayout()
        layoutIfNeeded()
        return systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
    }
    
    static func animate(idx: TimeInterval, views: [UIView?]) {
        let delay = idx * 0.1 + 0.3
        animate(delay: delay, views: views)
    }
    
    static func animate(delay: TimeInterval, views: [UIView?]) {
        for i in views {
            if let i = i {
                i.layer.transform = CATransform3DMakeScale(0.03, 0.03, 1)
                i.alpha = 0
            }
        }
        
        for i in views {
            if let i = i {
                UIView.animate(withDuration: 0.5,
                               delay: delay,
                               usingSpringWithDamping: 10.0,
                               initialSpringVelocity: 50.0,
                               options: .beginFromCurrentState,
                               animations: {
                                i.layer.transform = CATransform3DIdentity
                                i.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func pulsate() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = 1
        animation.fromValue = 0.975
        animation.toValue = 1.025
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        //        animation.initialVelocity = 0.5
        animation.damping = 1.0
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: nil)
    }
}


extension UIView {
    
    /// Create snapshot
    ///
    /// - parameter rect: The `CGRect` of the portion of the view to return. If `nil` (or omitted),
    ///                   return snapshot of the whole view.
    ///
    /// - returns: Returns `UIImage` of the specified portion of the view.
    
    func snapshot(of rect: CGRect? = nil) -> UIImage? {
        // snapshot entire view
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // if no `rect` provided, return image of whole view
        
        guard let image = wholeImage, let rect = rect else { return wholeImage }
        
        // otherwise, grab specified `rect` of image
        
        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }
    
}


extension UIView {
    
    var safeArea: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        }
        return self.snp
    }
}

extension UIView {
    public func autolayout(_ enabled: Bool) {
        translatesAutoresizingMaskIntoConstraints = !enabled
    }
    
    public func fadeIn() {
        alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1.0
        }
    }
    
    public func fadeOut(willRemove: Bool = true) {
        alpha = 1.0
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.alpha = 0.0
        }, completion:{ [unowned self] finished in
            if finished {
                self.removeFromSuperview()
            }
        })
    }
}

