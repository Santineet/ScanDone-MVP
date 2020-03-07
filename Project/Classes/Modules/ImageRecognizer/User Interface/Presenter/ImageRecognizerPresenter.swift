//
//  ImageRecognizerPresenter.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class ImageRecognizerPresenter: RootPresenter {
    
    var wireframe: ImageRecognizerWireframe!
    weak var userInterface: ImageRecognizerViewController!
    var interactor: ImageRecognizerInteractorInput!
    
    var image = UIImage()

    deinit {
        
    }
    
    var initialLoad = false
}

extension ImageRecognizerPresenter: ImageRecognizerModuleInterface {
    
    func viewDidLoad() {
        userInterface.textView.showLoadingHud(true, color: .white)
         
    }
    
    func viewDidAppear() {
        if !initialLoad {
            initialLoad = true
            interactor.recognize(image)
        }
    }
    
    func didSelectCopy() {
        var text = userInterface.textView.text
        if let textRange = userInterface.textView.selectedTextRange {
            text = userInterface.textView.text(in: textRange) ?? text
        }
        
        UIPasteboard.general.string = text
    }
    
    func didSelectShare() {
        guard let text = userInterface.textView.text else { return }
        wireframe.presentShareInterface(text)
    }
    
    func didSelectRecognizeLang() {
        userInterface.textView.text = nil
        userInterface.textView.showLoadingHud(true, color: .white)
        interactor.recognize(image)
    }
    
}


extension ImageRecognizerPresenter: ImageRecognizerInteractorOutput {
    
    func didRecognize(_ text: String?) {
        guard userInterface != nil else { return }
        
        userInterface.textView.text = text
        userInterface.noContentView.show(text?.isEmpty ?? false)
        userInterface.textView.showLoadingHud(false)
    }

}


//METHODS
extension ImageRecognizerPresenter {
    
    func dismiss() {
        wireframe.dismissInterface()
    }
}
