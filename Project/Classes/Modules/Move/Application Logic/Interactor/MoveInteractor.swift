//
//  MoveInteractor.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class MoveInteractor {
    var dataManagerAPI: MoveDataManagerAPI!
    var dataManagerLocal: MoveDataManagerLocal!
    weak var output: MoveInteractorOutput!
    
    deinit {
        
    }
}

extension MoveInteractor: MoveInteractorInput {
    
    public func loadList() {
        weak var weakSelf = self
        let dataManagerLocal = FolderListDataManagerLocal()
        dataManagerLocal.loadList { (items) in
            weakSelf?.output.didLoadedList(items)
        }
    }
}
