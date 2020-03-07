//
//  HorizontalMenuWireframe.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class HorizontalMenuWireframe: Wireframe {
    
    //MARK: BASE INIT

    let kHorizontalMenuViewControllerKey = "HorizontalMenuViewController"
    
    weak var presenter: HorizontalMenuPresenter!
    weak var userInterface: HorizontalMenuViewController!
    
    var userInterfaceNavigation: UINavigationController {
        let nvc = userInterface.navigationController ?? UINavigationController(rootViewController: userInterface)
        nvc.modalPresentationStyle = .overFullScreen
        return nvc
    }
    
    override init() {
        super.init()
        
        let userInterface = Wireframe.createViewController(
            withKey: kHorizontalMenuViewControllerKey,
            storyboardName: R.storyboard.horizontalMenu.name
            ) as! HorizontalMenuViewController
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
    
    func setupModule(userInterface: HorizontalMenuViewController) {
        let interactor = HorizontalMenuInteractor()
        let dataManagerAPI = HorizontalMenuDataManagerAPI()
        let dataManagerLocal = HorizontalMenuDataManagerLocal()
        let presenter = HorizontalMenuPresenter()
        
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
    
    //MARK: CUSTOM INIT

}


extension HorizontalMenuWireframe: HorizontalMenuWireframeInput {
    func presentInterface(_ presentingVC: UIViewController, animated: Bool = false, completion: (() -> Void)? = nil) {
        if userInterface.push {
            presentingVC.navigationController?.pushViewController(userInterface, animated: animated)
        } else {
            (presentingVC.navigationController ?? presentingVC).present(userInterfaceNavigation, animated: animated, completion: completion)
        }
    }
    
    func dismissInterface(animated: Bool = true, completion: (() -> Void)? = nil) {
        if userInterface.push {
            userInterface?.navigationController?.popViewController(animated: animated)
        } else {
            (userInterface?.navigationController ?? userInterface).dismiss(animated: animated, completion: completion)
        }
    }
}


//METHODS
extension HorizontalMenuWireframe {
    
}


