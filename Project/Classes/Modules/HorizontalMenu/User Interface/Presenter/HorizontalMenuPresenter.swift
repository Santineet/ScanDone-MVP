//
//  HorizontalMenuPresenter.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class HorizontalMenuPresenter {
    
    var wireframe: HorizontalMenuWireframe!
    weak var userInterface: HorizontalMenuViewController!
    var interactor: HorizontalMenuInteractorInput!
    
    weak var delegate: HorizontalMenuDelegate?
        
    deinit {
        
    }
}

extension HorizontalMenuPresenter: HorizontalMenuModuleInterface {
    
    func viewDidLoad() {

    }
    
    func didSelect(_ item: HorizontalMenuItem) {
        delegate?.moduleHorizontalMenu_didSelect(item)
    }
    
}


extension HorizontalMenuPresenter: HorizontalMenuInteractorOutput {
    
}



//METHODS
extension HorizontalMenuPresenter {
    
}
