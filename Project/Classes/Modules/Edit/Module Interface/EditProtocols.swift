//
//  EditProtocols.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


protocol EditDataManagerAPIInput: class {
    
}


protocol EditDataManagerLocalInput: class {
    
}


protocol EditInteractorInput: class {

}


protocol EditInteractorOutput: class {

}


protocol EditModuleInterface: class {
    var delegate: EditDelegate? {get set}
    var item: FolderItem? {get set}
    var dataSource: [ImportItem] {get set}
    var type: EditPresenterType! {get set}

    func viewDidLoad()
    func didSelectCancel()
    func didSelectDone()
    func didSelectDelete()
    func didSelectCrop()
    func didSelectFilter(_ filter: FilterItem, _ indexPath: IndexPath)
    func didSelectRotate()
    func didSelectAdd()
    func didSelectImageRecognizer() 
}


protocol EditViewInterface: class {
    
}


protocol EditWireframeInput: class {
    
    
}


protocol EditDelegate: class {
    var dataSource: [ImportItem] {get set}
    var item: FolderItem? {get set}

}

