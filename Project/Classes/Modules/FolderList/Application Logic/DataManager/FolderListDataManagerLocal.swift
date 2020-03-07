//
//  FolderListDataManagerLocal.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class FolderListDataManagerLocal {

    deinit {
        
    }
}


extension FolderListDataManagerLocal: FolderListDataManagerLocalInput {
    
    func loadList(_ completion: ((_ items: [FolderItem]) -> Void)! = nil) {
        DispatchQueue.main.async {
            let items = FolderItem.mr_findAllSorted(by: FolderItemAttributes.id.rawValue, ascending: false) as! [FolderItem]
            completion(items)
//            DispatchQueue.main.async {
//            }
        }
    }
}

