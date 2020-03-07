//
//  AboutPresenter.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class AboutPresenter: RootPresenter {
    
    var wireframe: AboutWireframe!
    weak var userInterface: AboutViewController!
    var interactor: AboutInteractorInput!
    
    deinit {
        
    }
}

extension AboutPresenter: AboutModuleInterface {
    
    func viewDidLoad() {

    }

}


extension AboutPresenter: AboutInteractorOutput {
    
    
}



//METHODS
extension AboutPresenter {
   
    
}
