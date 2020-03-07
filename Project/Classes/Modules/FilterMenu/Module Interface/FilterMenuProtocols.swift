//
//  FilterMenuProtocols.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

protocol FilterMenuDataManagerAPIInput: class {

}


protocol FilterMenuDataManagerLocalInput: class {
    
    
}


protocol FilterMenuInteractorInput: class {
    
}


protocol FilterMenuInteractorOutput: class {
    
}


protocol FilterMenuModuleInterface: class {
    
    func viewDidLoad()
    func didSelect(_ item: FilterMenuItem)
}


protocol FilterMenuViewInterface: class {
    func reloadData()
}


protocol FilterMenuWireframeInput: class {
    
    
}

protocol FilterMenuDelegate: class {
    func moduleFilterMenu_didSelect(_ item: FilterMenuItem)
}
