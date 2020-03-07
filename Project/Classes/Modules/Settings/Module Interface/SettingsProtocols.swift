//
//  SettingsProtocols.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


protocol SettingsDataManagerAPIInput: class {

}


protocol SettingsDataManagerLocalInput: class {
    
    
}


protocol SettingsInteractorInput: class {
    
    func restore()
}


protocol SettingsInteractorOutput: class {
    
    func didRestore(_ error: Error?)
}


protocol SettingsModuleInterface: class {
    
    func viewDidLoad()
    func didSelectClose()
    func didSelectRestore()
    func didSelectPrivacy()
    func didSelectTerms()
    func didSelectSupport()
    func didSelectSubscription()
    func didSelectClearCache()
}


protocol SettingsViewInterface: class {
    
}


protocol SettingsWireframeInput: class {
    
    
}


protocol SettingsDelegate: class {
    
    
}

