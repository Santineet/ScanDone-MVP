//
//  SplashWireframe.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class SplashWireframe: Wireframe {
    
    //MARK: BASE INIT
    
    let kSplashViewControllerKey = "SplashViewController"
    
    weak var presenter: SplashPresenter!
    weak var userInterface: SplashViewController!
    
    var userInterfaceNavigation: UINavigationController {
        let nvc = userInterface.navigationController ?? UINavigationController(rootViewController: userInterface)
        nvc.modalPresentationStyle = .fullScreen
        return nvc
    }
    
    override init() {
        super.init()
        
        let userInterface = Wireframe.createViewController(withKey: kSplashViewControllerKey) as! SplashViewController
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
    
    func setupModule(userInterface: SplashViewController) {
        let interactor = SplashInteractor()
        let dataManagerAPI = SplashDataManagerAPI()
        let dataManagerLocal = SplashDataManagerLocal()
        let presenter = SplashPresenter()
        
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

extension SplashWireframe: SplashWireframeInput {
    func presentInterface(_ presentingVC: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let nav = presentingVC.navigationController else { return }
        if userInterface.push {
            nav.pushViewController(userInterface, animated: animated)
        } else {
            nav.present(userInterfaceNavigation, animated: animated, completion: completion)
        }
    }
    
    func dismissInterface(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let nav = userInterface.navigationController else { return }
        if userInterface.push {
            nav.popViewController(animated: animated)
        } else {
            nav.dismiss(animated: animated, completion: completion)
        }
    }
}


//METHODS
extension SplashWireframe {
    
    func presentFolderListInterface() {
        guard let window = AppDependencies.appDelegate.window else { return }
        AppDependencies.shared.folderListWireframe = FolderListWireframe(window: window)
        AppDependencies.shared.splashWireframe = nil
    }
}
