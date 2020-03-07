//
//  NamePresenter.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class NamePresenter: RootPresenter {
    
    var wireframe: NameWireframe!
    weak var userInterface: NameViewController!
    var interactor: NameInteractorInput!
    weak var delegate: NameDelegate?
    
    var itemId: String!
    
    var item: FolderItem? {
        return FolderItem.by(id: itemId)
    }
    
    deinit {
        
    }
}

extension NamePresenter: NameModuleInterface {
    
    func viewDidLoad() {
        let item = self.item
        userInterface.textField.text = item?.name
    }

    func didSelectClose() {
        dismiss()
    }
 
    func didSelectDone() {
        if let newName = userInterface.textField.text, !newName.isEmpty {
            guard newName.count > 0 else {
                dismiss()
                return
            }
            
            let item = self.item
            if newName != item?.name {
                item?.name = newName
                NSManagedObjectContext.save()
                delegate?.moduleName_didUpdateName()
            }
            dismiss()
        } else {
            
        }
    }
}


extension NamePresenter: NameInteractorOutput {
    
}



//METHODS
extension NamePresenter {
    
    func dismiss() {
        userInterface.animateDisappearance { [weak self] in
            self?.wireframe.dismissInterface()
        }
    }
}
