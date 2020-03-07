//
//  PreviewInteractor.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class PreviewInteractor {

    var dataManagerAPI: PreviewDataManagerAPI!
    var dataManagerLocal: PreviewDataManagerLocal!
    weak var output: PreviewInteractorOutput!
    
}


extension PreviewInteractor: PreviewInteractorInput {
    
}


