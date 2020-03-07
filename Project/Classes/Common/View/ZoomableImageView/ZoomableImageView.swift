//
//  EEZoomableImageView.swift
//  EEZoomableImageView
//
//  Created by Emre on 27.05.2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import UIKit

class ZoomableImageView: EEZoomableImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        minZoomScale = 1
        maxZoomScale = 5.0
        resetAnimationDuration = 0.5
    }
}

