//
//  PurchaseItem.swift
//  Project
//
//  Created by Igor Bizi, laptop2 on 22/10/2018.
//  Copyright © 2018 Igor Bizi. All rights reserved.
//


enum FilterItem: Int {
    case original = 0
    case coloured
    case mono
    case bw

    var title: String {
        switch self {
        case .coloured: return "Coloured".localized.uppercased()
        case .mono: return "Mono".localized.uppercased()
        case .bw: return "B/W".localized.uppercased()
        case .original: return "Original".localized.uppercased()
        }
    }
    
    static var allCases: [FilterItem] = [original, coloured, mono, bw]
    
    func apply(_ image: UIImage) -> UIImage {
        var newImage = image
        switch self {
        case .coloured:
            newImage = newImage.kf.adjusted(brightness: 0, contrast: 1.0, saturation: 1, inputEV: 1)
        case .bw://bad
            newImage = newImage.kf.adjusted(brightness: 0.0, contrast: 1, saturation: 0.0, inputEV: 1)
        case .mono:
            newImage = newImage.kf.adjusted(brightness: 0.0, contrast: 1.0, saturation: 0.0, inputEV: 0.7)
        case .original:
           break
        }
        return newImage
    }
}

//https://github.com/WeTransfer/WeScan/pull/159
//https://github.com/onevcat/Kingfisher/wiki/Cheat-Sheet
//https://stackoverflow.com/questions/40178846/convert-uiimage-to-grayscale-keeping-image-quality
