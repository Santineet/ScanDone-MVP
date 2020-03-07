//
//  ImageRecognizerDataManagerLocal.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit
import SwiftyTesseract


//https://www.raywenderlich.com/2010498-tesseract-ocr-tutorial-for-ios
//https://github.com/gali8/Tesseract-OCR-iOS

//https://github.com/tesseract-ocr/tesseract/wiki/Data-Files#data-files-for-version-304305
//https://github.com/tesseract-ocr/tessdata_best
//https://github.com/tesseract-ocr/langdata
//https://github.com/tesseract-ocr/tessdata


class ImageRecognizerDataManagerLocal {

    var tesseract: SwiftyTesseract?

    deinit {
        tesseract = nil
    }
}


extension ImageRecognizerDataManagerLocal: ImageRecognizerDataManagerLocalInput {
    
    func recognize(image: UIImage, language: ImageRecognizerLanguageItem, completion: @escaping ((_ text : String?, _ image : UIImage) -> Void)) {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.tesseract = nil
            let tesseract = SwiftyTesseract(language: language.recognitionLanguage, bundle: .main, engineMode: .tesseractLstmCombined)
            tesseract.performOCR(on: image) { recognizedString in
                DispatchQueue.main.async {
                    completion(recognizedString, image)
                }
            }
            self?.tesseract = tesseract
        }
    }
    
    func recognize(images: [UIImage?], language: ImageRecognizerLanguageItem, completion: @escaping ((_ text : String?) -> Void)) {
        guard let items = (images.filter { $0 != nil }) as? [UIImage], items.isEmpty == false else { return completion(nil) }
        
        var results = [UIImage: String]()
        
        for item in items {
            recognize(image: item, language: language) { (text, image) in
                results[image] = text ?? ""
                
                if results.count == items.count {
                    var result = ""
                    for (index,i) in items.enumerated() {
                        if let j = results[i], j.isEmpty == false {
                            result += j + (index != items.count-1 ? "\n" : "")
                        }
                    }
                    completion(result)
                }
            }
        }
    }
}

