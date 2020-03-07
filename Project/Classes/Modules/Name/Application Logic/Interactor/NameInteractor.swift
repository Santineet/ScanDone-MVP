//
//  NameInteractor.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class NameInteractor {
    
    var dataManagerAPI: NameDataManagerAPI!
    var dataManagerLocal: NameDataManagerLocal!
    weak var output: NameInteractorOutput!
    
}


extension NameInteractor: NameInteractorInput {
     
}


