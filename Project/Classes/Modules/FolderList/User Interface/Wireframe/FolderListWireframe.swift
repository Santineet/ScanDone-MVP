//
//  FolderListWireframe.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class FolderListWireframe: Wireframe {
    
    //MARK: BASE INIT
    
    let kFolderListViewControllerKey = "FolderListViewController"
    
    weak var presenter: FolderListPresenter!
    weak var userInterface: FolderListViewController!
    
    var userInterfaceNavigation: UINavigationController {
        let nvc = userInterface.navigationController ?? UINavigationController(rootViewController: userInterface)
        nvc.modalPresentationStyle = .fullScreen
        return nvc
    }
    
    override init() {
        super.init()
        
        let userInterface = Wireframe.createViewController(withKey: kFolderListViewControllerKey) as! FolderListViewController
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
    
    func setupModule(userInterface: FolderListViewController) {
        let interactor = FolderListInteractor()
        let dataManagerAPI = FolderListDataManagerAPI()
        let dataManagerLocal = FolderListDataManagerLocal()
        let presenter = FolderListPresenter()
        
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

extension FolderListWireframe: FolderListWireframeInput {
    
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
extension FolderListWireframe {
    
    func presentSettingsInterface() {
        let wireframe = SettingsWireframe()
        wireframe.presentInterface(userInterface)
    }
    
    func presentAboutInterface() {
        let wireframe = AboutWireframe()
        wireframe.presentInterface(userInterface)
    }
    
    func presentScanInterface() {
        guard ScanPermissionPresenter.shared.isAllowed() else { return }
        let imageScannerController = ImageScannerController(type: .create)
        imageScannerController.modalPresentationStyle = .fullScreen
        userInterface.present(imageScannerController, animated: true)
    }
    
    func presentFolderInterface(_ item: FolderItem) {
        let wireframe = FolderWireframe()
        wireframe.presenter.itemId = item.id
        wireframe.presentInterface(userInterface)
    }
    
    func presentShareInterface(_ item: FolderItem) {
        let wireframe = ShareWireframe()
        wireframe.presentInterface(userInterface, folder: item, files: item.files)
    }
    
    func presentNameInterface(_ item: FolderItem) {
        let wireframe = NameWireframe()
        wireframe.presenter.itemId = item.id
        wireframe.presenter.delegate = presenter
        wireframe.presentInterface(userInterface)
    }
    
    func presentOnboardingInterface() {
        let wireframe = OnboardingWireframe()
        wireframe.presentInterface(userInterface)
    }
    
    func presentSubscriptionInterface() {
        let wireframe = SubscriptionWireframe()
        wireframe.presenter.presentType = .folderList
        wireframe.presentInterface(userInterface)
    }
    
    func presentEditInterface(_ item: FolderItem) {
        var items = [ImportItem]()
        for i in item.files {
            if let item = ImportItem.createFrom(i) {
                items.append(item)
            }
        }
        
        let imageScannerController = ImageScannerController(item: item, type: .edit)
        let scannerViewController = (imageScannerController.viewControllers.first as? ScannerViewController)
        scannerViewController?.dataSource = items
        scannerViewController?.presentEditInterface(animated: false)
        imageScannerController.modalPresentationStyle = .fullScreen
        userInterface.present(imageScannerController, animated: true)
    }
}

 
