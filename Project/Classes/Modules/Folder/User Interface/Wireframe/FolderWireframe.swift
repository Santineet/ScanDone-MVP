//
//  DocumentWireframe.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class FolderWireframe: Wireframe {
    
    //MARK: BASE INIT
    
    let kFolderViewControllerKey = "FolderViewController"
    
    weak var presenter: FolderPresenter!
    weak var userInterface: FolderViewController!
    
    lazy var userInterfaceNavigation: UINavigationController = {
        let nvc = userInterface.navigationController ?? UINavigationController(rootViewController: userInterface)
        return nvc
    }()
    
    override init() {
        super.init()
        
        let userInterface = Wireframe.createViewController(withKey: kFolderViewControllerKey) as! FolderViewController
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
    
    func setupModule(userInterface: FolderViewController) {
        let interactor = FolderInteractor()
        let dataManagerAPI = FolderDataManagerAPI()
        let dataManagerLocal = FolderDataManagerLocal()
        let presenter = FolderPresenter()
        
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

extension FolderWireframe: FolderWireframeInput {
    
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
extension FolderWireframe {
    
    func presentPreviewInterface(_ indexPath: IndexPath) {
        let wireframe = PreviewWireframe()
        wireframe.presenter.delegate = presenter
        wireframe.userInterface.initialIndexPath = indexPath
        wireframe.presentInterface(userInterface)
    }
    
    func presentScanInterface(_ item: FolderItem) {
        guard ScanPermissionPresenter.shared.isAllowed() else { return }
        let vc = ImageScannerController(item: item, type: .append)
        vc.modalPresentationStyle = .fullScreen
        userInterface.present(vc, animated: true)
    }
    
    func presentShareInterface(_ document: FolderItem, _ files: [FileItem]) {
        let wireframe = ShareWireframe()
        wireframe.presentInterface(userInterface, folder: document, files: files)
    }
    
    func presentNameInterface() {
        let wireframe = NameWireframe()
        wireframe.presenter.delegate = presenter
        wireframe.presenter.itemId = presenter.item.id
        wireframe.presentInterface(userInterface)
    }
    
    func presentMoveCopyInterface(_ type: MovePresenterType, _ files: [FileItem]) {
        let wireframe = MoveWireframe()
        wireframe.presenter.type = type
        wireframe.presenter.files = files
        wireframe.presenter.itemId = presenter.itemId
        wireframe.presentInterface(userInterface)
    }
    
    func presentEditInterface(_ item: FolderItem, _ indexPath: IndexPath? = nil) {
        var items = [ImportItem]()
        for i in item.files {
            if let item = ImportItem.createFrom(i) {
                items.append(item)
            }
        }
        
        let imageScannerController = ImageScannerController(item: item, type: .edit)
        let scannerViewController = (imageScannerController.viewControllers.first as? ScannerViewController)
        scannerViewController?.dataSource = items
        scannerViewController?.presentEditInterface(indexPath: indexPath, animated: false)
        imageScannerController.modalPresentationStyle = .fullScreen
        userInterface.present(imageScannerController, animated: true)
    }
}
