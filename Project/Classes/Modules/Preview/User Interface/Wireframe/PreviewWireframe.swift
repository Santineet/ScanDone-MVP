//
//  PreviewWireframe.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class PreviewWireframe: Wireframe {
    
    //MARK: BASE INIT

    let kPreviewViewControllerKey = "PreviewViewController"
    
    weak var presenter: PreviewPresenter!
    weak var userInterface: PreviewViewController!
    
    var userInterfaceNavigation: UINavigationController {
        let nvc = userInterface.navigationController ?? UINavigationController(rootViewController: userInterface)
        nvc.modalPresentationStyle = .fullScreen
        return nvc
    }
        
    override init() {
        super.init()
        
        let userInterface = Wireframe.createViewController(withKey: kPreviewViewControllerKey, storyboard: .Main) as! PreviewViewController
        setupModule(userInterface: userInterface)
    }
    
    convenience init(window: UIWindow?) {
        self.init()
        if let window = window {
            
            window.rootViewController = userInterfaceNavigation
            window.makeKeyAndVisible()
        }
    }
    
    func setupModule(userInterface: PreviewViewController) {
        let interactor = PreviewInteractor()
        let dataManagerAPI = PreviewDataManagerAPI()
        let dataManagerLocal = PreviewDataManagerLocal()
        let presenter = PreviewPresenter()
        
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


extension PreviewWireframe: PreviewWireframeInput {
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
extension PreviewWireframe {

    func presentShareInterface(_ files: [FileItem]) {
        guard let item = presenter.delegate?.item else { return }
        let wireframe = ShareWireframe()
        wireframe.presentInterface(userInterface, folder: item, files: files)
    }
    
}

