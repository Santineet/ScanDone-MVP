//
//  FilterMenuPresenter.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class FilterMenuPresenter {
    
    var wireframe: FilterMenuWireframe!
    weak var userInterface: FilterMenuViewController!
    var interactor: FilterMenuInteractorInput!
    
    weak var delegate: FilterMenuDelegate?
        
    deinit {
        
    }
}

extension FilterMenuPresenter: FilterMenuModuleInterface {
    
    func viewDidLoad() {

    }
    
    func didSelect(_ item: FilterMenuItem) {
        delegate?.moduleFilterMenu_didSelect(item)
    }
    
}


extension FilterMenuPresenter: FilterMenuInteractorOutput {
    
}



//METHODS
extension FilterMenuPresenter {
    
}
