//
//  FolderListPresenter.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class FolderListPresenter {
    var wireframe: FolderListWireframe!
    weak var userInterface: FolderListViewController!
    var interactor: FolderListInteractorInput!
    
    deinit {
        
    }
    
    var initialLoad = true
}

extension FolderListPresenter: FolderListModuleInterface {
    
    func viewDidLoad() {
        presentOnboardingInterface()
        if App.showPremiumOnStart {
            wireframe.presentSubscriptionInterface()
        }
        userInterface.reloadData()
        loadList()
    }

    func viewWillAppear() {
        if !initialLoad {
            loadList(isSilent: !initialLoad)
        }
        initialLoad = false
    }
    
    func didSelectImportPhotos() {
        wireframe.presentScanInterface()
    }
    
    func didSelectClose() {
        wireframe.dismissInterface()
    }
    
    func didSelect(_ indexPath: IndexPath) {
        let item = userInterface.dataSource[indexPath.item]
        wireframe.presentFolderInterface(item)
    }
    
    func didSelectSetting() {
        wireframe.presentSettingsInterface()
    }
    
    func didSelectMenu(_ selector: Selector, _ indexPath: IndexPath) {
        let document = userInterface.dataSource[indexPath.item]

        switch selector {
        case .onRename:
            didSelectRename(document, indexPath)
        case .onDelete:
            didSelectDelete(document, indexPath)
        case .onEdit:
            didSelectEdit(document, indexPath)
        case .onShare:
            didSelectShare(document, indexPath)
        default: break
        }
    }
    
    func didSelectEdit(_ document: FolderItem, _ indexPath: IndexPath) {
        wireframe.presentEditInterface(document)
    }
    
    func didSelectShare(_ document: FolderItem, _ indexPath: IndexPath) {
        wireframe.presentShareInterface(document)
    }
    
    func didSelectRename(_ document: FolderItem, _ indexPath: IndexPath) {
        wireframe.presentNameInterface(document)
    }
    
    func didSelectDelete(_ document: FolderItem, _ indexPath: IndexPath) {
//        guard let cell = userInterface.collectionView.cellForItem(at: indexPath) else {
//            return
//        }
        
        weak var weakSelf = self
        Alert.show(style: .actionSheet, okTitle: "Delete".localized.uppercased(), okButton: true, okStyle: .destructive, cancelButton: true, cancelTitle: "Cancel".localized.uppercased(), sourceView: userInterface.horizontalMenuView, okEventHandler: { (_) in
           
            var dataSource = weakSelf?.userInterface.dataSource ?? []
            dataSource.remove(object: document)
            weakSelf?.userInterface.dataSource = dataSource
            
            document.delete({ (error) in
                weakSelf?.userInterface.collectionView.performBatchUpdates({
                    weakSelf?.userInterface.collectionView.deleteItems(at: [indexPath])
                }, completion: { (finished) in
                    if dataSource.isEmpty {
                        weakSelf?.loadList()
                    }
                })
            })
        })
    }
    
    func didSelectAbout() {
        wireframe.presentAboutInterface()
    }
}


extension FolderListPresenter: FolderListInteractorOutput {
    
    func didLoadedList(_ items: [FolderItem]) {
        guard userInterface != nil else {
            return
        }
        
        userInterface.showLoadingHud(false)
        userInterface.dataSource = items
        userInterface.reloadData()
        userInterface.showNoContent(items.isEmpty)
    }
    
    func loadList(isSilent: Bool = false) {
        userInterface.showLoadingHud(!isSilent)
        interactor.loadList()
    }
}



//METHODS
extension FolderListPresenter {
    private func presentOnboardingInterface() {
        if !App.skipOnboarding && App.statusPurchaseOn {
            if App.alwaysShowOnboarding || !InAppPurchaseDataManagerAPI.isActive() {
                wireframe.presentOnboardingInterface()
            }
        }
    }
}

extension FolderListPresenter: NameDelegate {
    
    func moduleName_didUpdateName()  {
        loadList(isSilent: true)
    }
    
}
