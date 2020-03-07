//
//  PHAsset.swift
//  PhotoCompress
//
//  Created by Igor Bizi, laptop2 on 06/12/2018.
//  Copyright © 2018 MainasuK. All rights reserved.
//

import UIKit
import Photos

extension PHAsset {
    
    public static func fetchLastPhoto(
        scaleTo size: CGSize?,
        complete: @escaping (UIImage?) -> Void
        ) {
        DispatchQueue.global(qos: .background).async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchOptions.fetchLimit = 1
            let results = fetchAssets(with: .image, options: fetchOptions)
            guard let asset = results.firstObject else {
                DispatchQueue.main.async { complete(nil) }
                return
            }
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = false
            requestOptions.isNetworkAccessAllowed = true
            requestOptions.version = .original
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.resizeMode = .exact
            
            let targetSize = size ?? CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            PHImageManager.default()
                .requestImage(
                    for: asset,
                    targetSize: targetSize,
                    contentMode: .aspectFill,
                    options: requestOptions)
                { image, _ in DispatchQueue.main.async { complete(image) } }
        }
    }
    
}

extension PHAsset {
    
    static func fromFileURL(url: URL) -> PHAsset? {
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.version = .current
        imageRequestOptions.deliveryMode = .fastFormat
        imageRequestOptions.resizeMode = .fast
        imageRequestOptions.isSynchronous = true
        
        let fetchResult = PHAsset.fetchAssets(with: nil)
        for index in 0..<fetchResult.count {
            let asset = fetchResult[index]
            var found = false
            PHImageManager.default().requestImageData(for: asset, options: imageRequestOptions) { (_, _, _, info) in
                if let urlkey = info?["PHImageFileURLKey"] as? NSURL {
                    if urlkey.absoluteString! == url.absoluteString {
                        found = true
                    }
                }
            }
            if (found) {
                return asset
            }
            
        }
        
        return nil
    }
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
    
    //icloud supported
    func getImage(completion: @escaping ((_ image: UIImage?) -> Void)) {
        if self.mediaType == .image {
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
            options.version = .original
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            options.progressHandler = { [weak self] (progress, error, stop, info) in
                guard let `self` = self else { return }
                print("\(self.localIdentifier): \(progress)")
            }
            PHImageManager.default().requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (image, info) in
                completion(image)
            }
        } else {
            completion(nil)
        }
    }
    
    @discardableResult
    func getImageData(completion: @escaping ((_ data: Data?, _ asset: PHAsset?) -> Void)) -> PHImageRequestID? {
        if self.mediaType == .image {
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
            options.version = .original
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            options.progressHandler = { [weak self] (progress, error, stop, info) in
                guard let `self` = self else { return }
                print("\(self.localIdentifier): \(progress)")
            }
            return PHImageManager.default().requestImageData(for: self, options: options) { (data, _, _, _) in
                completion(data, self)
            }
        } else {
            completion(nil, self)
            return nil
        }
    }
    
//    func getFileSize(completion: @escaping ((_ fileSize: Int?, _ asset: PHAsset?) -> Void)) {
//        if self.mediaType == .image {
//            let options = PHContentEditingInputRequestOptions()
//            options.isNetworkAccessAllowed = true
////            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
////                return true
////            }
//            options.progressHandler = { [weak self] (progress, _) in
//                completion(nil, self)
//                guard let `self` = self else { return }
//                print("\(self.localIdentifier): \(progress)")
//            }
//            self.requestContentEditingInput(with: options) { (contentEditingInput, _) in
//                do {
//                    let fileSize = try contentEditingInput?.fullSizeImageURL?.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).fileSize
//                    //print("file size: \(String(describing: fileSize))")
//                    completion(fileSize, self)
//                } catch let error {
//                    print("error: \(error)")
//                    completion(nil, self)
//                }
//            }
//        } else {
//            completion(nil, self)
//        }
//    }
    
    //icloud does not supported
    func getImageUrl(completion: @escaping ((_ url: URL?) -> Void)) {
        if self.mediaType == .image {
            let options = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completion(contentEditingInput?.fullSizeImageURL)
            })
        } else {
            completion(nil)
        }
    }
    
    func getURLVideo(completion: @escaping ((_ url: URL?) -> Void)) {
        if self.mediaType == .video {
            let options = PHVideoRequestOptions()
            options.isNetworkAccessAllowed = true
            options.version = .original
            options.deliveryMode = .highQualityFormat
            options.progressHandler = { [weak self] (progress, error, stop, info) in
                guard let `self` = self else { return }
                 print("\(self.localIdentifier): \(progress)")
            }
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    completion(urlAsset.url)
                } else {
                    completion(nil)
                }
            })
        } else {
            completion(nil)
        }
    }
    
    var originalFilename: String? {
        if #available(iOS 9.0, *) {
            return PHAssetResource.assetResources(for: self).first?.originalFilename
        } else {
            return nil
        }
    }
    
    var originalFileExtension: String? {
        if #available(iOS 9.0, *) {
            return PHAssetResource.assetResources(for: self).first?.uniformTypeIdentifier
        } else {
            return nil
        }
    }
    var fileSize: Int {
        if #available(iOS 10.0, *) {
            let v = PHAssetResource.assetResources(for: self).first?.value(forKey: "fileSize") as? Int
            return v ?? 0
        }
        return 0
    }
    
    var filenameF: String? {
        return value(forKey: "filename") as? String
    }
    
    var fileExtension: String? {
        if let filename = filenameF {
            return URL(string: filename)?.pathExtension
        }
//        if let value = value(forKey: "uniformTypeIdentifier") as? String {
//            return value
//        }
        return nil
    }
    
    func copy(toFolder: String, completion: @escaping (() -> Void)) {
        getImageData { (data, asset) in
            if let asset = asset, let data = data {
                let name = asset.originalFilename ?? String.createIdFromTodayDate()
                var toPath = toFolder + "/" + name
                if FileManager.default.fileExists(atPath: toPath) {
                    if name == asset.originalFilename {
                        if let ext = name.components(separatedBy: ".").last {
                            var newname = name.replacingOccurrences(of: ext, with: "")
                            while FileManager.default.fileExists(atPath: toPath) {
                                newname += " copy"
                                toPath = URL(fileURLWithPath: toFolder).appendingPathComponent(newname+"."+ext).path
                            }
                        }
                    } else {
                        toPath = toFolder + "/" + String.createIdFromTodayDate()
                    }
                }
                (data as NSData).write(toFile: toPath, atomically: true)
                completion()
            } else {
                completion()
            }
        }
    }
}
