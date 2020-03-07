//
//  ImageRecognizerProtocols.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


protocol ImageRecognizerDataManagerAPIInput: class {

}


protocol ImageRecognizerDataManagerLocalInput: class {
    func recognize(image: UIImage, language: ImageRecognizerLanguageItem, completion: @escaping ((_ text : String?, _ image : UIImage) -> Void))
    
}


protocol ImageRecognizerInteractorInput: class {
    func recognize(_ image: UIImage)
}


protocol ImageRecognizerInteractorOutput: class {
    func didRecognize(_ text: String?) 

}


protocol ImageRecognizerModuleInterface: class {
    
    func viewDidLoad()
    func viewDidAppear()
    func didSelectCopy()
    func didSelectShare()
    func didSelectRecognizeLang()
}


protocol ImageRecognizerViewInterface: class {
    
}


protocol ImageRecognizerWireframeInput: class {
    
    
}


protocol ImageRecognizerDelegate: class {
    
    
}

