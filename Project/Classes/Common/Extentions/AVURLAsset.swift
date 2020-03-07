//
//  PHAsset.swift
//  PhotoCompress
//
//  Created by Igor Bizi, laptop2 on 06/12/2018.
//  Copyright © 2018 MainasuK. All rights reserved.
//

import Photos

extension AVURLAsset {
    
    static func generateThumbnail(url: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imageGenerator.copyCGImage(at: CMTime.zero, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch let error as NSError {
            print("error in generateThumbnail")
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func generateThumbnail(url: URL, completion: @escaping ((_ image : UIImage?) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            do {
                let asset = AVURLAsset(url: url)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                imageGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imageGenerator.copyCGImage(at: CMTime.zero, actualTime: nil)
                let image = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    completion(image)
                }
            } catch let error as NSError {
                print("error in generateThumbnail")
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
}
