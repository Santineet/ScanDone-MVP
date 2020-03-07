//
//  SettingsWireframe.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class SettingsWireframe: Wireframe {
    
    //MARK: BASE INIT

    let kSettingsViewControllerKey = "SettingsViewController"
    
    weak var presenter: SettingsPresenter!
    weak var userInterface: SettingsViewController!
    
    var userInterfaceNavigation: UINavigationController {
        let nvc = userInterface.navigationController ?? UINavigationController(rootViewController: userInterface) 
        nvc.modalTransitionStyle = .crossDissolve
        nvc.modalPresentationStyle = .overFullScreen
        return nvc
    }
        
    override init() {
        super.init()
        
        let userInterface = Wireframe.createViewController(withKey: kSettingsViewControllerKey, storyboard: .Main) as! SettingsViewController
        setupModule(userInterface: userInterface)
    }
    
    convenience init(window: UIWindow?) {
        self.init()
        if let window = window {
            
            window.rootViewController = userInterfaceNavigation
            window.makeKeyAndVisible()
        }
    }
    
    func setupModule(userInterface: SettingsViewController) {
        let interactor = SettingsInteractor()
        let dataManagerAPI = SettingsDataManagerAPI()
        let dataManagerLocal = SettingsDataManagerLocal()
        let presenter = SettingsPresenter()
        
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


extension SettingsWireframe: SettingsWireframeInput {
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
extension SettingsWireframe {
 
    func presentMailInterface() {
        func appInfo() -> String {
            let prefferedLanguage = Locale.preferredLanguages.first
            let language = prefferedLanguage?.components(separatedBy: "-").first ?? "" //system
            let country = Locale.current.regionCode ?? ""
            let locale = language + "_" + country //  zh_CN
            
            let systemVersion = UIDevice.current.systemVersion
            let device = Device.current
            
            var result = ""
            result += "- App version: \(App.name) \(Bundle.main.versionNumber) (\(Bundle.main.buildNumber))"
            result += "\n"
            result += "- Device model: \(device)"
            result += "\n"
            result += "- System version: \(UIDevice.current.systemName) \(systemVersion)"
            result += "\n"
            result += "- Locale: \(locale)"
            if let id = AppSettings.uId {
                let newId = id.replacingOccurrences(of: "binom_", with: "").replacingOccurrences(of: "uid_", with: "")
                result += "\n"
                result += "- User id: \(newId)"
            }
            return result
        }
        
        let subject = String.localizedStringWithFormat(NSLocalizedString("[%@ iOS] Feedback", comment: ""), App.name)
        presentMailInterface(recipients: [App.contactEmail], subject: subject, body: "\n\n\n\n\(appInfo())")
    }
    
    func presentSubscriptionInterface() {
        let wireframe = SubscriptionWireframe()
        wireframe.presenter.presentType = .settings
        wireframe.presenter.delegate = presenter
        wireframe.presentInterface(userInterface)
    }
    
    func presentClearCacheInterface() {
        Alert.show(style: .actionSheet, okTitle: "Clear cache".localized.uppercased(), okButton: true, cancelButton: true, cancelTitle: "Cancel".localized.uppercased(), sourceView: userInterface.tableView, okEventHandler: { (_) in
            FolderItem.clearTemp()
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk(onCompletion: {
            })
        })
    }
}


