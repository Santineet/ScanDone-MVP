//
//  SettingsInteractor.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class SettingsInteractor {

    var dataManagerAPI: SettingsDataManagerAPI!
    var dataManagerLocal: SettingsDataManagerLocal!
    weak var output: SettingsInteractorOutput!
    
}


extension SettingsInteractor: SettingsInteractorInput {

    func restore() {
        let dataManager = SubscriptionDataManagerAPI()
        weak var weakSelf = self
        dataManager.restore { (error) in
            DispatchQueue.main.async {
                weakSelf?.output?.didRestore(error)
            }
        }
    }
    
}


