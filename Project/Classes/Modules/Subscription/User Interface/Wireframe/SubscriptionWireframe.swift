//
//  SubscriptionWireframe.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class SubscriptionWireframe: Wireframe {
    
    //MARK: BASE INIT

    let kSubscriptionViewControllerKey = "SubscriptionViewController"
    
    weak var presenter: SubscriptionPresenter!
    weak var userInterface: SubscriptionViewController!
    
    var userInterfaceNavigation: UINavigationController {
        let nvc = userInterface.navigationController ?? UINavigationController(rootViewController: userInterface)
        nvc.modalPresentationStyle = .fullScreen
        return nvc
    }
        
    override init() {
        super.init()
        
        let userInterface = Wireframe.createViewController(withKey: kSubscriptionViewControllerKey, storyboard: .Main) as! SubscriptionViewController
        setupModule(userInterface: userInterface)
    }
    
    convenience init(window: UIWindow?) {
        self.init()
        if let window = window {
            
            window.rootViewController = userInterfaceNavigation
            window.makeKeyAndVisible()
        }
    }
    
    func setupModule(userInterface: SubscriptionViewController) {
        let interactor = SubscriptionInteractor()
        let dataManagerAPI = SubscriptionDataManagerAPI()
        let dataManagerLocal = SubscriptionDataManagerLocal()
        let presenter = SubscriptionPresenter()
        
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


extension SubscriptionWireframe: SubscriptionWireframeInput {
    func presentInterface(_ presentingVC: UIViewController, animated: Bool = true) {
        if userInterface.push {
            presentingVC.navigationController?.pushViewController(userInterface, animated: animated)
        } else {
            presentingVC.navigationController?.present(userInterfaceNavigation, animated: animated, completion: nil)
        }
    }
    
    func dismissInterface(animated: Bool = true) {
        if userInterface.push {
            userInterface?.navigationController?.popViewController(animated: animated)
        } else {
            userInterface.navigationController?.dismiss(animated: animated, completion: nil)
        }
    }
}


//METHODS
extension SubscriptionWireframe {
 
}


