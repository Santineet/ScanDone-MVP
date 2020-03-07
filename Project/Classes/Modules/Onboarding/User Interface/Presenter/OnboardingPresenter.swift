//
//  OnboardingPresenter.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class OnboardingPresenter: RootPresenter {
    
    var wireframe: OnboardingWireframe!
    weak var userInterface: OnboardingViewController!
    var interactor: OnboardingInteractorInput!
    
    //MARK: Properties
    weak var delegate: OnboardingDelegate?
    
    private static let kDidShowOnboardingKey = "AppSettings-kDidShowOnboardingKey"
    static var didShowOnboarding: Bool {
        get {
            return UserDefaults.standard.bool(forKey: kDidShowOnboardingKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kDidShowOnboardingKey)
        }
    }
}

// MARK: - OnboardingModuleInterface
extension OnboardingPresenter: OnboardingModuleInterface {
    
    func viewDidLoad() {
        userInterface.reloadData()
    }
    
    func didScrollToPageAtIndex(_ index: Int) {
        
    }
    
    func didReachRightEdge() {
        OnboardingPresenter.didShowOnboarding = true
        wireframe.presentSubscriptionInterface()
    }
    
    func didSelectDone() {
        didReachRightEdge()
    }
    
}

// MARK: - OnboardingInteractorOutput
extension OnboardingPresenter: OnboardingInteractorOutput {
    
}

extension OnboardingPresenter {
    
}

extension OnboardingPresenter: SubscriptionDelegate {
    
    func moduleSubscription_didClose() {
        wireframe.dismissInterface()
    }
}
