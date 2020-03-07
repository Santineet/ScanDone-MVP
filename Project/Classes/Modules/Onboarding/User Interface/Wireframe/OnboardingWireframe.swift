//
//  OnboardingWireframe.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class OnboardingWireframe: Wireframe {
    
    let kOnboardingViewControllerKey = "OnboardingViewController"
    
    weak var presenter: OnboardingPresenter!
    weak var userInterface: OnboardingViewController!
    
    var userInterfaceNavigation: UINavigationController {
        let nvc = userInterface.navigationController ?? UINavigationController(rootViewController: userInterface)
        nvc.modalPresentationStyle = .fullScreen
        return nvc
    }
    
    override init() {
        super.init()
        
        let userInterface = Wireframe.createViewController(withKey: kOnboardingViewControllerKey) as! OnboardingViewController
        setupModule(userInterface: userInterface)
    }
    
    convenience init(window: UIWindow?) {
        self.init()
        if let window = window {
            
            window.rootViewController = userInterfaceNavigation
            window.makeKeyAndVisible()
        }
    }
    
    func setupModule(userInterface: OnboardingViewController) {
        let interactor = OnboardingInteractor()
        let dataManagerAPI = OnboardingDataManagerAPI()
        let dataManagerLocal = OnboardingDataManagerLocal()
        let presenter = OnboardingPresenter()
        
        presenter.wireframe = self;
        presenter.interactor = interactor;
        
        interactor.dataManagerAPI = dataManagerAPI;
        interactor.dataManagerLocal = dataManagerLocal;
        interactor.output = presenter;
        
        presenter.userInterface = userInterface;
        userInterface.eventHandler = presenter;
        
        self.userInterface = userInterface
        self.presenter = presenter        
    }
}

extension OnboardingWireframe: OnboardingWireframeInput {
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

extension OnboardingWireframe {
    func presentSubscriptionInterface() {
        let wireframe = SubscriptionWireframe()
        wireframe.presenter.presentType = .onboarding
        wireframe.presenter.delegate = presenter
        wireframe.presentInterface(userInterface)
    }
}
