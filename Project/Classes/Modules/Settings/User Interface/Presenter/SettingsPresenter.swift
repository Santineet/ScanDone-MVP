//
//  SettingsPresenter.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class SettingsPresenter: RootPresenter {
    
    var wireframe: SettingsWireframe!
    weak var userInterface: SettingsViewController!
    var interactor: SettingsInteractorInput!
    
    deinit {
        
    }
}

extension SettingsPresenter: SettingsModuleInterface {
    
    func viewDidLoad() {

    }
    
    func didSelectRestore() {
        userInterface.view.showLoadingHud(true)
        userInterface.showContent(false)
        interactor.restore()
    }
    
    func didSelectClose() {
        dismiss()
    }
    
    func didSelectPrivacy() {
        wireframe.presentSafariInterface(userInterface, url: URL.init(string: App.privacyUrlString)!)
    }
    
    func didSelectTerms() {
        wireframe.presentSafariInterface(userInterface, url: URL.init(string: App.termsUrlString)!)
    }
    
    func didSelectSubscription() {
        wireframe.presentSubscriptionInterface()
    }
    
    func didSelectClearCache() {
        wireframe.presentClearCacheInterface()
    }
}


extension SettingsPresenter: SettingsInteractorOutput {
    
    func didRestore(_ error: Error?) {
        userInterface.view.showLoadingHud(false)
        userInterface.showContent(true)
        
        weak var weakSelf = self
        delay(1) {
            if InAppPurchaseDataManagerAPI.isActive() && error == nil {
                weakSelf?.dismiss()
                delay(0.5, closure: {
                    Alert.showSuccess(body: "Membership successfully restored!".localized)
                })
            } else if let error = error {
                Alert.showError(error.localizedDescription)
            } else {
                Alert.showError("Please try again or contact us".localized)
            }
        }
    }
    
    func didSelectSupport() {
        wireframe.presentMailInterface()
    }
}



//METHODS
extension SettingsPresenter {
    
    func dismiss() {
        wireframe.dismissInterface()
    }
}

extension SettingsPresenter: SubscriptionDelegate {
    
    func moduleSubscription_didClose() {
        
    }
}
