//
//  LanguageProtocols.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


protocol MoveDataManagerAPIInput: class {
    
}

protocol MoveDataManagerLocalInput: class {

}

protocol MoveInteractorInput: class {
    func loadList()
}

protocol MoveInteractorOutput: class {
    func didLoadedList(_ items: [FolderItem])
}

protocol MoveModuleInterface: class {
    var selectedItem: FolderItem? { set get }
    
    func viewDidLoad()
    func viewWillAppear()
    func didSelectClose()
    func didSelectDone()
    
    func canSelect(_ folder: FolderItem) -> Bool
    func didSelect(_ folder: FolderItem, _ indexPath: IndexPath)
}

protocol MoveViewInterface: class {
    
    var dataSource: [FolderItem] { set get }
    func reloadData()
    func reloadNaviationItems(_ title: String)
}

protocol MoveWireframeInput: class {

}


protocol MoveDelegate: class {
    
}
