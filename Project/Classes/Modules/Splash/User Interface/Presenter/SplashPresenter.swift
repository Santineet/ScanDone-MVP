//
//  SplashPresenter.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class SplashPresenter {
    var wireframe: SplashWireframe!
    weak var userInterface: SplashViewController!
    var interactor: SplashInteractorInput!
    
    deinit {
        
    }
}


extension SplashPresenter: SplashModuleInterface {
    
    func viewDidLoad() {
        
    }

    func viewWillAppear() {
        
    }
    
    func animationDidStop() {
        wireframe.presentFolderListInterface()
    }
}


extension SplashPresenter: SplashInteractorOutput {
    
}



//METHODS
extension SplashPresenter {
    
}

