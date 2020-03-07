//
//  LanguageProtocols.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


/// Inputs - APIs
protocol FolderListDataManagerAPIInput: class {
    
}

/// Inputs - Local Storage
protocol FolderListDataManagerLocalInput: class {

}

// MARK: - Interactor Protocols

protocol FolderListInteractorInput: class {
    func loadList()
}

protocol FolderListInteractorOutput: class {
    func didLoadedList(_ items: [FolderItem])
}

// MARK: - Presenter Protocols
protocol FolderListModuleInterface: class {
    func viewDidLoad()
    func viewWillAppear()
    func didSelectImportPhotos()
    func didSelectClose()
    func didSelectSetting()
    func didSelectAbout()
    
    func didSelectMenu(_ selector: Selector, _ indexPath: IndexPath)
    func didSelect(_ indexPath: IndexPath)
}

protocol FolderListViewInterface: class {
    
    var dataSource: [FolderItem] { set get }
    func reloadData()
}

// MARK: - Router Protocols

protocol FolderListWireframeInput: class {
    func presentScanInterface()
    func presentFolderInterface(_ item: FolderItem)
    func presentOnboardingInterface()
}


protocol FolderListDelegate: class {
    
}
