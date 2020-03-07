//
//  ImageRecognizerWireframe.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class ImageRecognizerWireframe: Wireframe {
    
    //MARK: BASE INIT

    let kImageRecognizerViewControllerKey = "ImageRecognizerViewController"
    
    weak var presenter: ImageRecognizerPresenter!
    weak var userInterface: ImageRecognizerViewController!
    
    var userInterfaceNavigation: UINavigationController {
        let nvc = userInterface.navigationController ?? UINavigationController(rootViewController: userInterface) 
//        nvc.isNavigationBarHidden = true
//        nvc.modalTransitionStyle = .crossDissolve
        nvc.modalPresentationStyle = .overFullScreen
        return nvc
    }
        
    override init() {
        super.init()
        
        let userInterface = Wireframe.createViewController(withKey: kImageRecognizerViewControllerKey, storyboard: .Main) as! ImageRecognizerViewController
        setupModule(userInterface: userInterface)
    }
    
    convenience init(window: UIWindow?) {
        self.init()
        if let window = window {
            
            window.rootViewController = userInterfaceNavigation
            window.makeKeyAndVisible()
        }
    }
    
    func setupModule(userInterface: ImageRecognizerViewController) {
        let interactor = ImageRecognizerInteractor()
        let dataManagerAPI = ImageRecognizerDataManagerAPI()
        let dataManagerLocal = ImageRecognizerDataManagerLocal()
        let presenter = ImageRecognizerPresenter()
        
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


extension ImageRecognizerWireframe: ImageRecognizerWireframeInput {
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
extension ImageRecognizerWireframe {
    
    func presentShareInterface(_ text: String) {
        let viewController = UIActivityViewController(activityItems: [text], applicationActivities: [])
        userInterface.present(viewController, animated: true, completion: nil)
    }
}


