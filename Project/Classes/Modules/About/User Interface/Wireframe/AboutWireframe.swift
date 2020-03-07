//
//  AboutWireframe.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class AboutWireframe: Wireframe {
    
    //MARK: BASE INIT

    let kAboutViewControllerKey = "AboutViewController"
    
    weak var presenter: AboutPresenter!
    weak var userInterface: AboutViewController!
    
    var userInterfaceNavigation: UINavigationController {
        let nvc = userInterface.navigationController ?? UINavigationController(rootViewController: userInterface)
        nvc.modalPresentationStyle = .fullScreen
        return nvc
    }
        
    override init() {
        super.init()
        
        let userInterface = Wireframe.createViewController(withKey: kAboutViewControllerKey, storyboard: .Main) as! AboutViewController
        setupModule(userInterface: userInterface)
    }
    
    convenience init(window: UIWindow?) {
        self.init()
        if let window = window {
            
            window.rootViewController = userInterfaceNavigation
            window.makeKeyAndVisible()
        }
    }
    
    func setupModule(userInterface: AboutViewController) {
        let interactor = AboutInteractor()
        let dataManagerAPI = AboutDataManagerAPI()
        let dataManagerLocal = AboutDataManagerLocal()
        let presenter = AboutPresenter()
        
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


extension AboutWireframe: AboutWireframeInput {
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
extension AboutWireframe {
 
}


