//
//  EditWireframe.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class EditWireframe: Wireframe {
    
    //MARK: BASE INIT

    let kEditViewControllerKey = "EditViewController"
    
    weak var presenter: EditPresenter!
    weak var userInterface: EditViewController!
    
    var userInterfaceNavigation: UINavigationController {
        let nvc = userInterface.navigationController ?? UINavigationController(rootViewController: userInterface)
        nvc.modalPresentationStyle = .fullScreen
        return nvc
    }
        
    override init() {
        super.init()
        
        let userInterface = Wireframe.createViewController(withKey: kEditViewControllerKey, storyboard: .Main) as! EditViewController
        setupModule(userInterface: userInterface)
    }
    
    convenience init(window: UIWindow?) {
        self.init()
        if let window = window {
            
            window.rootViewController = userInterfaceNavigation
            window.makeKeyAndVisible()
        }
    }
    
    func setupModule(userInterface: EditViewController) {
        let interactor = EditInteractor()
        let dataManagerAPI = EditDataManagerAPI()
        let dataManagerLocal = EditDataManagerLocal()
        let presenter = EditPresenter()
        
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


extension EditWireframe: EditWireframeInput {
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
extension EditWireframe {

    func presentCropInterface(_ image: UIImage, _ quad: Quadrilateral?) {
        let scannerViewController = ImageScannerController(image: image, savedQuad: quad, delegate: presenter)
        scannerViewController.modalPresentationStyle = .fullScreen
        userInterface.present(scannerViewController, animated: true)
    }
    
    func presentImageRecognizerInterface(_ item: ImportItem) {
        let wireframe = ImageRecognizerWireframe()
        wireframe.presenter.image = item.display
        wireframe.presentInterface(userInterface)
    }
}

