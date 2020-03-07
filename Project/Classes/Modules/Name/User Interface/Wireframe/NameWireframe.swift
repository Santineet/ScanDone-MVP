//
//  NameWireframe.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class NameWireframe: Wireframe {
    
    //MARK: BASE INIT
    
    let kNameViewControllerKey = "NameViewController"
    
    weak var presenter: NamePresenter!
    weak var userInterface: NameViewController!
    
    var userInterfaceNavigation: UINavigationController {
        let nvc = userInterface.navigationController ?? UINavigationController(rootViewController: userInterface)
        nvc.isNavigationBarHidden = true
        nvc.modalPresentationStyle = .overFullScreen
        return nvc
    }
    
    override init() {
        super.init()
        
        let userInterface = Wireframe.createViewController(withKey: kNameViewControllerKey) as! NameViewController
        setupModule(userInterface: userInterface)
    }
    
    deinit {
        
    }
    
    convenience init(window: UIWindow?) {
        self.init()
        if let window = window {
            
            window.rootViewController = userInterfaceNavigation
            window.makeKeyAndVisible()
        }
    }
    
    func setupModule(userInterface: NameViewController) {
        let interactor = NameInteractor()
        let dataManagerAPI = NameDataManagerAPI()
        let dataManagerLocal = NameDataManagerLocal()
        let presenter = NamePresenter()
        
        presenter.wireframe = self
        presenter.interactor = interactor
        
        interactor.dataManagerAPI = dataManagerAPI
        interactor.dataManagerLocal = dataManagerLocal
        interactor.output = presenter
        
        presenter.userInterface = userInterface
        userInterface.eventHandler = presenter
        
        self.userInterface = userInterface
        self.presenter = presenter
    }
    
}

extension NameWireframe: NameWireframeInput {
    
    func presentInterface(_ presentingVC: UIViewController, animated: Bool = false, completion: (() -> Void)? = nil) {
        guard let nav = presentingVC.navigationController else { return }
        if userInterface.push {
            nav.pushViewController(userInterface, animated: animated)
        } else {
            nav.present(userInterfaceNavigation, animated: animated, completion: completion)
        }
    }
    
    func dismissInterface(animated: Bool = false, completion: (() -> Void)? = nil) {
        guard let nav = userInterface.navigationController else { return }
        if userInterface.push {
            nav.popViewController(animated: animated)
        } else {
            nav.dismiss(animated: animated, completion: completion)
        }
    }
}



//METHODS
extension NameWireframe {
 
  
}


