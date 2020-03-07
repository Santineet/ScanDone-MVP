//
//  OBProtocols.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

protocol OnboardingDataManagerAPIInput: class {
    
}

protocol OnboardingDataManagerLocalInput: class {
    
}

protocol OnboardingInteractorInput: class {
    
}

protocol OnboardingInteractorOutput: class {
    
}

protocol OnboardingModuleInterface: class {
    func viewDidLoad()
    func didScrollToPageAtIndex(_ index: Int)
    func didReachRightEdge()
    func didSelectDone()
}

protocol OnboardingViewInterface: class {
    func reloadData()
}

protocol OnboardingWireframeInput: class {

}

protocol OnboardingDelegate: class {
    
}

