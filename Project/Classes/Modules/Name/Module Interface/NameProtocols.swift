//
//  NameProtocols.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


protocol NameDataManagerAPIInput: class {
    
}


protocol NameDataManagerLocalInput: class {
    
}


protocol NameInteractorInput: class {

}


protocol NameInteractorOutput: class {

}


protocol NameModuleInterface: class {
    var itemId: String! {get set}
    
    func viewDidLoad()
    func didSelectClose()
    func didSelectDone()
}


protocol NameViewInterface: class {
    
}


protocol NameWireframeInput: class {
    
    
}


protocol NameDelegate: class {
    func moduleName_didUpdateName() 
}

