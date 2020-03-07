//
//  DocumentPresenter.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class FolderPresenter {
    var wireframe: FolderWireframe!
    weak var userInterface: FolderViewController!
    var interactor: FolderInteractorInput!
    
    deinit {
        
    }
    
    var itemId: String!
    
    var item: FolderItem {
        return FolderItem.by(id: itemId)!
    }
    
    var initialLoad = true
    
}


extension FolderPresenter: FolderModuleInterface {
    
    func viewDidLoad() {
        loadList()
    }
    
    func viewWillAppear() {
        if !initialLoad {
            loadList()
        }
        initialLoad = false
    }
    
    func viewDidAppear() {
        
    }
    
    func didSelectItem(_ indexPath: IndexPath) {
        wireframe.presentPreviewInterface(indexPath)
    }
    
    func didDrag(_ indexPath1: IndexPath, _ indexPath2: IndexPath) {
        FolderItem.reoder(item, indexPath1.item, indexPath2.item)
    }
    
    func didSelectShare(_ indexPath: [IndexPath]) {
        let files = indexPath.map { item.files[$0.row] }
        wireframe.presentShareInterface(item, files)
    }
    
    func didSelectDelete(_ indexPath: [IndexPath]) {
        let files = indexPath.map { item.files[$0.row] }
        let isDeleteDocument = files.count == item.filePaths.count
        let title = isDeleteDocument ? "Delete document".localized.uppercased() : "Delete".localized.uppercased()
        weak var weakSelf = self
        Alert.show(style: .actionSheet, okTitle: title, okButton: true, okStyle: .destructive, cancelButton: true, cancelTitle: "Cancel".localized.uppercased(), sourceView: userInterface.horizontalMenuView, okEventHandler: { (_) in
            
            if isDeleteDocument {
                weakSelf?.item.delete({ (error) in
                    weakSelf?.wireframe.dismissInterface()
                })
            } else {
                weakSelf?.item.deleteFiles(files, { (error) in
                    weakSelf?.userInterface.collectionView.performBatchUpdates({
                        weakSelf?.userInterface.collectionView.deleteItems(at: indexPath)
                    }, completion: { (finished) in
                       weakSelf?.loadList()
                    })
                })
            }
        })
    }
    
    func didSelectAdd() {
        wireframe.presentScanInterface(item)
    }

    func didSelectMove(_ indexPath: [IndexPath]) {
        let files = indexPath.map { item.files[$0.row] }

        weak var weakSelf = self
        let actionCopy = UIAlertAction(title: "Copy".localized, style: .default, handler: {(_) -> Void in
            weakSelf?.wireframe.presentMoveCopyInterface(.copy, files)
            weakSelf?.userInterface.stopSelection(withDelay: true)
        })
        let actionMove = UIAlertAction(title: "Move".localized, style: .default, handler: {(_) -> Void in
            weakSelf?.wireframe.presentMoveCopyInterface(.move, files)
            weakSelf?.userInterface.stopSelection(withDelay: true)
        })
        Alert.show(style: .actionSheet, okButton: false, cancelButton:true, cancelTitle: "Cancel".localized, actions: [actionCopy, actionMove])
    }
    
    func didSelectEdit() {
        wireframe.presentEditInterface(item)
    }
    
    func didSelectNavigationTitle() {
        wireframe.presentNameInterface()
    }
    
    func didSelectMore() {
        let indexPath = userInterface.selectedIndexPaths
        let files = indexPath.map { item.files[$0.row] }

        weak var weakSelf = self
        let actionCopy = UIAlertAction(title: "Copy".localized.uppercased(), style: .default, handler: {(_) -> Void in
            weakSelf?.wireframe.presentMoveCopyInterface(.copy, files)
            weakSelf?.userInterface.stopSelection(withDelay: true)
        })
        let actionMove = UIAlertAction(title: "Move".localized.uppercased(), style: .default, handler: {(_) -> Void in
            weakSelf?.wireframe.presentMoveCopyInterface(.move, files)
            weakSelf?.userInterface.stopSelection(withDelay: true)
        })
        let actionExport = UIAlertAction(title: "Export".localized.uppercased(), style: .default, handler: {(_) -> Void in
            weakSelf?.didSelectShare(indexPath)
        })
        Alert.show(style: .actionSheet, okButton: false, cancelButton:true, cancelTitle: "Cancel".localized.uppercased(), actions: [actionMove, actionCopy, actionExport])
    }
}


extension FolderPresenter: FolderInteractorOutput {
    
}



//METHODS
extension FolderPresenter {
    
    func loadList() {
        userInterface.reloadData()
        userInterface.reloadCount()
        userInterface.reloadTitle()
    }
    
}

extension FolderPresenter: PreviewDelegate {
    
    func didSelectEdit(_ indexPath: IndexPath) {
        wireframe.presentEditInterface(item, indexPath)
    }
}

extension FolderPresenter: NameDelegate {
    
    func moduleName_didUpdateName()  {
        userInterface.reloadTitle()
    }
    
}



