//
//  SubscriptionPresenter.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

enum SubscriptionPresentType {
    case settings, onboarding, folderList
}

class SubscriptionPresenter: RootPresenter {
    
    var wireframe: SubscriptionWireframe!
    weak var userInterface: SubscriptionViewController!
    var interactor: SubscriptionInteractorInput!
    
    var presentType = SubscriptionPresentType.onboarding
    
    weak var delegate: SubscriptionDelegate?
    
    deinit {
        
    }
}

extension SubscriptionPresenter: SubscriptionModuleInterface {
    
    func viewDidLoad() {
        loadList()
    }

    func didSelectItem(_ item: SubscriptionItem) {
        userInterface.showLoadingHud(true)
        userInterface.showContent(false)
        interactor.buy(item)
    }
    
    func didSelectRestore() {
        userInterface.showLoadingHud(true)
        userInterface.showContent(false)
        interactor.restore()
    }
    
    func didSelectClose() {
        if App.unlockPremiumAfterClosePurchaseScreen {
            App.unlockPremium = !App.unlockPremium
            NotificationCenter.default.post(name: .InAppPurchaseDataManagerDidBuy, object: nil)
        }
        
        dismiss()
    }
    
    func didSelectPrivacy() {
        wireframe.presentSafariInterface(userInterface, url: URL.init(string: App.privacyUrlString)!)
    }
    
    func didSelectTerms() {
        wireframe.presentSafariInterface(userInterface, url: URL.init(string: App.termsUrlString)!)
    }
    
    func didSelectRefresh() {
        userInterface.dataSource = []
        userInterface.reloadData()
        loadList()
    }
}


extension SubscriptionPresenter: SubscriptionInteractorOutput {
    
    func didLoadList(_ items: [SubscriptionItem], error: Error?) {
        userInterface.showLoadingHud(false)
        if let week = items.filter({ $0.type == PurchaseItem.Weekly }).first, let month = items.filter({ $0.type == PurchaseItem.Monthly }).first, let month3 = items.filter({ $0.type == PurchaseItem.Monthly3 }).first {
            userInterface.dataSource = [week, month, month3]
        }
        userInterface.showNoContent(items.isEmpty)
        userInterface.reloadData()
        
        if let error = error {
            Alert.showError(error.localizedDescription)
        }
    }
    
    func didBuy(_ error: Error?) {
        userInterface.showLoadingHud(false)
        userInterface.showContent(true)
        
        weak var weakSelf = self
        delay(1) {
            if InAppPurchaseDataManagerAPI.isActive() && error == nil {
                NetworkManager.shared.logAnalytics(.trialStart)
                weakSelf?.dismiss()
            } else if let _ = error {
            } else {
                Alert.showError("Please try again or contact us".localized)
            }
        }
    }
    
    func didRestore(_ error: Error?) {
        userInterface.showLoadingHud(false)
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
}



//METHODS
extension SubscriptionPresenter {
    
    func loadList() {
        userInterface?.tableView?.stopRefreshing()
        userInterface.showLoadingHud(true)
        userInterface.showNoContent(false)
        interactor.loadList()
    }
    
    func dismiss() {
        if !userInterface.push {
            wireframe.dismissInterface()
        }
        
        guard let delegate = delegate else { return }
        delegate.moduleSubscription_didClose()
    }
}
