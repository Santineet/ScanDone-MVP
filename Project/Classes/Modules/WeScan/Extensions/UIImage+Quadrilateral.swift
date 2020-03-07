//
//  UIImage+Quadrilateral.swift
//  Project
//
//  Created by Shane Gao on 2019/8/6.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import Foundation

extension UIImage {
    
    public func crop(quad: Quadrilateral, quadViewSize: CGSize? = CGSize.zero, withRotationAngle: CGFloat = 0.0) -> ImageEditResults? {
        guard let ciImage = CIImage(image: self) else { return nil }
        
        let cgOrientation = CGImagePropertyOrientation(imageOrientation)
        let orientedImage = ciImage.oriented(forExifOrientation: Int32(cgOrientation.rawValue))
        
        //let scaledQuad = quad.scale(quadViewSize, size)
        var scaledQuad = quad
        if let quadViewSize = quadViewSize {
            //if withRotationAngle > 0 || withRotationAngle < 0 {
               // scaledQuad = quad.scale(quadViewSize, size, withRotationAngle: withRotationAngle)
           // } else {
                scaledQuad = quad.scale(quadViewSize, size)
           // }
        }
    
        // Cropped Image
        var cartesianScaledQuad = scaledQuad.toCartesian(withHeight: size.height)
        cartesianScaledQuad.reorganize()
        
        let filteredImage = orientedImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: cartesianScaledQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: cartesianScaledQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: cartesianScaledQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: cartesianScaledQuad.topRight)
            ])
        
        let image = UIImage.from(ciImage: filteredImage)
        let results = ImageEditResults.init(image: image, quad: scaledQuad, quadViewSize: quadViewSize ?? CGSize.zero)
        return results
    }
        
    public func resultsWithQuad(
        _ quad: Quadrilateral, enhanced: Bool = false
    ) -> ImageScannerResults? {
        guard let ciImage = CIImage(image: self) else { return nil }
        
        let cgOrientation = CGImagePropertyOrientation(imageOrientation)
        let orientedImage = ciImage.oriented(forExifOrientation: Int32(cgOrientation.rawValue))
        
        // Cropped Image
        var cartesianScaledQuad = quad.toCartesian(withHeight: size.height)
        cartesianScaledQuad.reorganize()
        
        let filteredImage = orientedImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: cartesianScaledQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: cartesianScaledQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: cartesianScaledQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: cartesianScaledQuad.topRight)
            ])
        
        let croppedImage = UIImage.from(ciImage: filteredImage)
        
        var results = ImageScannerResults(detectedRectangle: quad, originalScan: ImageScannerScan(image: self), croppedScan: ImageScannerScan(image: croppedImage), enhancedScan: nil)
        
        if enhanced {
            let enhancedImage = filteredImage.applyingAdaptiveThreshold()?.withFixedOrientation()
            results.enhancedScan = enhancedImage.flatMap { ImageScannerScan(image: $0) }
        }
        
        return results
    }
}
