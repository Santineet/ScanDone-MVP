//
//  LanguageProtocols.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


/// Inputs - APIs
protocol SplashDataManagerAPIInput: class {
    
}

/// Inputs - Local Storage
protocol SplashDataManagerLocalInput: class {

}

// MARK: - Interactor Protocols

protocol SplashInteractorInput: class {
    
}

protocol SplashInteractorOutput: class {

}

// MARK: - Presenter Protocols
protocol SplashModuleInterface: class {
    func viewDidLoad()
    func viewWillAppear()
    func animationDidStop() 
}

protocol SplashViewInterface: class {
    
}

// MARK: - Router Protocols

protocol SplashWireframeInput: class {
    
}


protocol SplashDelegate: class {
    
}
