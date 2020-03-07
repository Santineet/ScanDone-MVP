//
//  MovePresenter.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


enum MovePresenterType {
    case move, copy
}

extension MovePresenterType {
    
    var title: String {
        switch self {
        case .move: return "Move".localized.uppercased()
        case .copy: return "Copy".localized.uppercased()
        }
    }
    
}

class MovePresenter {
    var wireframe: MoveWireframe!
    weak var userInterface: MoveViewController!
    var interactor: MoveInteractorInput!
    
    deinit {
        
    }
    
    var initialLoad = true
    
    var type = MovePresenterType.move
    var files = [FileItem]()
    var itemId: String!
    
    lazy var fromFolderItem: FolderItem = {
        return FolderItem.by(id: itemId)!
    }()
    
    weak var selectedItem: FolderItem?
}

extension MovePresenter: MoveModuleInterface {
    
    func viewDidLoad() {
        userInterface.reloadNaviationItems(type.title)
        userInterface.reloadData()
        loadList()
    }

    func viewWillAppear() {
        if !initialLoad {
            loadList(isSilent: !initialLoad)
        }
        initialLoad = false
    }
    
    func didSelectClose() {
        wireframe.dismissInterface()
    }
    
    func didSelectDone() {
        weak var weakSelf = self
        guard let folder = selectedItem else { return }
        userInterface.view.showLoadingHud(true, backgroundColor: UIColor._light1)
        delay(0.5) {
            if let weakSelf = weakSelf {
            FileItem.moveCopy(type: weakSelf.type, items: weakSelf.files, folder) { (error) in
                    weakSelf.userInterface?.view.showLoadingHud(false)
                    if let error = error {
                        Alert.showError(error)
                    } else {
                        weakSelf.wireframe.dismissInterface()
                    }
                }
            }
        }
    }
    
    func didSelect(_ folder: FolderItem, _ indexPath: IndexPath) {
        selectedItem = folder
        userInterface.reloadNaviationItems(type.title)
    }
    
    func canSelect(_ folder: FolderItem) -> Bool {
        switch type {
        case .move:
            return fromFolderItem != folder
        case .copy:
            return true
        }
    }
}


extension MovePresenter: MoveInteractorOutput {
    
    func didLoadedList(_ items: [FolderItem]) {
        guard userInterface != nil else {
            return
        }
        
        userInterface.showLoadingHud(false)
        userInterface.dataSource = items
        userInterface.reloadData()
    }
    
    func loadList(isSilent: Bool = false) {
        userInterface.showLoadingHud(!isSilent)
        interactor.loadList()
    }
}



//METHODS
extension MovePresenter {
    
    
}
