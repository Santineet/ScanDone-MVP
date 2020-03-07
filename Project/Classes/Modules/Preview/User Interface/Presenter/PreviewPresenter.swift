//
//  PreviewPresenter.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class PreviewPresenter: RootPresenter {
    
    var wireframe: PreviewWireframe!
    weak var userInterface: PreviewViewController!
    var interactor: PreviewInteractorInput!
    
    deinit {
    }
    
    weak var delegate: PreviewDelegate?
    
}

extension PreviewPresenter: PreviewModuleInterface {
    
    func viewDidLoad() {
        
    }
    
    func didSelectDelete() {
        guard let delegate = delegate, let visibleItem = visibleItem() else { return }
        let item = delegate.item
        
        let isDeleteFolder = item.filePaths.count == 1
        let title = isDeleteFolder ? "Delete document".localized.uppercased() : "Delete".localized.uppercased()
        weak var weakSelf = self
        Alert.show(style: .actionSheet, okTitle: title, okButton: true, okStyle: .destructive, cancelButton: true, cancelTitle: "Cancel".localized.uppercased(), sourceView: userInterface.horizontalMenuView, okEventHandler: { (_) in
            
            if isDeleteFolder {
                item.delete({ (error) in
                    weakSelf?.userInterface.navigationController?.popToRootViewController(animated: true)
                })
            } else {
                item.deleteFiles([visibleItem], { (error) in
                    weakSelf?.userInterface.reloadData()
                    delay(0.5, closure: {
                        weakSelf?.userInterface.reloadNavigationTitleForVisibleItem()
                    })
                })
            }
        })
    }
    
    func didSelectEdit() {
        guard let delegate = delegate, let indexPath = userInterface.visibleIndexPath() else { return }
        delegate.didSelectEdit(indexPath)
    }
    
    func didSelectShare() {
        guard let item = visibleItem() else { return }
        wireframe.presentShareInterface([item])
    }
    
    func didSelectMore() {
        didSelectShare()
    }
    
}


extension PreviewPresenter: PreviewInteractorOutput {
    
}



//METHODS
extension PreviewPresenter {
    
    func visibleItem() -> FileItem? {
        guard let delegate = delegate else { return nil }
        guard let indexPath = userInterface.visibleIndexPath() else { return nil }
        let index = indexPath.item
        guard index >= 0, index < delegate.item.count, delegate.item.count >= 0 else { return nil}
        let item = delegate.item.files[index]
        return item
    }
    
}


