//
//  AboutInteractor.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class AboutInteractor {

    var dataManagerAPI: AboutDataManagerAPI!
    var dataManagerLocal: AboutDataManagerLocal!
    weak var output: AboutInteractorOutput!
    
}


extension AboutInteractor: AboutInteractorInput {
 
}


