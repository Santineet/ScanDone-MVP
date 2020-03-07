//
//  AVPlayer.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 12/22/16.
//  Copyright © 2016 BEST. All rights reserved.
//

import UIKit
import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
    
    func snapshot(seconds: Double) -> UIImage? {
        if let asset = currentItem?.asset {
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            
            let timestamp = CMTime(seconds: seconds, preferredTimescale: 1)
            
            do {
                let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
                return UIImage(cgImage: imageRef)
            } catch let error as NSError {
                print("Image generation failed with error \(error)")
            }
        }
        return nil
    }
    
    func getUrl() -> URL? {
        let asset = currentItem?.asset
        if asset == nil {
            return nil
        }
        if let urlAsset = asset as? AVURLAsset {
            return urlAsset.url
        }
        return nil
    }
}
