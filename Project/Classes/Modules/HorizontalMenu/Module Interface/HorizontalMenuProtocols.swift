//
//  HorizontalMenuProtocols.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

protocol HorizontalMenuDataManagerAPIInput: class {

}


protocol HorizontalMenuDataManagerLocalInput: class {
    
    
}


protocol HorizontalMenuInteractorInput: class {
    
}


protocol HorizontalMenuInteractorOutput: class {
    
}


protocol HorizontalMenuModuleInterface: class {
    
    func viewDidLoad()
    func didSelect(_ item: HorizontalMenuItem)
}


protocol HorizontalMenuViewInterface: class {
    var dataSource: [HorizontalMenuItem] { get set }

    func reloadData()
}


protocol HorizontalMenuWireframeInput: class {
    
    
}

protocol HorizontalMenuDelegate: class {
    func moduleHorizontalMenu_didSelect(_ item: HorizontalMenuItem)
}
