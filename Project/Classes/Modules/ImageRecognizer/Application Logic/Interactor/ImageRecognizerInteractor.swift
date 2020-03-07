//
//  ImageRecognizerInteractor.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class ImageRecognizerInteractor {

    var dataManagerAPI: ImageRecognizerDataManagerAPI!
    var dataManagerLocal: ImageRecognizerDataManagerLocal!
    weak var output: ImageRecognizerInteractorOutput!

}


extension ImageRecognizerInteractor: ImageRecognizerInteractorInput {
    
    func recognize(_ image: UIImage) {
        dataManagerLocal.recognize(image: image, language: ImageRecognizerLanguageItem.selected) { [weak self] (text, image) in
            self?.output?.didRecognize(text)
        }
    }
}


