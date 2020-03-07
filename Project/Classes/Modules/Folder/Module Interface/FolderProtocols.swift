//
//  LanguageProtocols.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


/// Inputs - APIs
protocol FolderDataManagerAPIInput: class {
    
}

/// Inputs - Local Storage
protocol FolderDataManagerLocalInput: class {

}

// MARK: - Interactor Protocols

protocol FolderInteractorInput: class {
    
}

protocol FolderInteractorOutput: class {

}

// MARK: - Presenter Protocols
protocol FolderModuleInterface: class {
    var itemId: String! {get set}
    var item: FolderItem {get}

    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func didSelectItem(_ indexPath: IndexPath)
    func didDrag(_ indexPath1: IndexPath, _ indexPath2: IndexPath)
    
    func didSelectShare(_ indexPath: [IndexPath])
    func didSelectDelete(_ indexPath: [IndexPath])
    func didSelectAdd()
    func didSelectMove(_ indexPath: [IndexPath])
    func didSelectEdit()
    func didSelectNavigationTitle()
    func didSelectMore()
}

protocol FolderViewInterface: class {
    
}

// MARK: - Router Protocols

protocol FolderWireframeInput: class {
    
}


protocol FolderDelegate: class {
    
}
