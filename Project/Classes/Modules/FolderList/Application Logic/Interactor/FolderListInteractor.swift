//
//  FolderListInteractor.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class FolderListInteractor {
    var dataManagerAPI: FolderListDataManagerAPI!
    var dataManagerLocal: FolderListDataManagerLocal!
    weak var output: FolderListInteractorOutput!
    
    deinit {
        
    }
}

extension FolderListInteractor: FolderListInteractorInput {
    
    public func loadList() {
        weak var weakSelf = self
        dataManagerLocal.loadList { (items) in
            weakSelf?.output.didLoadedList(items)
        }
    }
}
