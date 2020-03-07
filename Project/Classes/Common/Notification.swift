//
//  Notification.swift
//  MusicPlayer
//
//  Created by IgorBizi@mail.ru on 8/4/17.
//  Copyright © 2017 IgorBizi@mail.ru. All rights reserved.
//

import Foundation

// MARK: - NotificationType

public protocol NotificationType {
    var name: Notification.Name { get }
}

extension NotificationType where Self: RawRepresentable, Self.RawValue == String {
    
    public var name: Notification.Name {
        return Notification.Name(rawValue)
    }
}

public enum Notices: String, NotificationType {
    case DidCloseOnboarding
}
/*
 
 static let WillDismissOnboarding = Notification.Name("WillDismissOnboarding")

 NotificationCenter.default.post(name: .WillDismissOnboarding, object: nil)

 
 NotificationCenter.default.removeObserver(self, name: .WillDismissOnboarding, object: nil)

 NotificationCenter.default.addObserver(self, selector: #selector(willDismissOnboarding), name: .WillDismissOnboarding, object: nil)

 @objc func willDismissOnboarding() {
    if userInterface != nil {
        interactor.loadPlayHistory()
    }
 }
 */
