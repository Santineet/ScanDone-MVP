//
//  Alert.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 4/15/17.
//  Copyright © 2017 BEST. All rights reserved.
//

import UIKit

class Alert {
    
    static func show(style: UIAlertController.Style = .alert,
                     title: String? = nil,
                     body: String? = nil,
                     okTitle: String = "OK".localized,
                     okButton: Bool = true,
                     okStyle: UIAlertAction.Style = .default,
                     cancelButton: Bool = false,
                     cancelTitle: String = "Cancel".localized,
                     cancelStyle: UIAlertAction.Style = .cancel,
                     sourceView: UIView? = nil,
                     sourceBarButtonItem: UIBarButtonItem? = nil,
                     sourceRect: CGRect? = nil,
                     completion: (() -> Void)! = nil,
                     okEventHandler: ((_ okAction: UIAlertAction) -> Void)! = nil,
                     cancelEventHandler: ((_ okAction: UIAlertAction) -> Void)! = nil,
                     actions: [UIAlertAction]? = nil,
                     viewControllerToPresent: UIViewController? = nil) {
        let controller = UIAlertController(title: title, message: body, preferredStyle: style)
        if sourceView != nil {
            controller.popoverPresentationController?.sourceView = sourceView
        }
        if let sourceRect = sourceRect {
            controller.popoverPresentationController?.sourceRect = sourceRect
        }
        if sourceBarButtonItem != nil {
            controller.popoverPresentationController?.barButtonItem = sourceBarButtonItem
        }
        if okButton {
            let actionOk = UIAlertAction(title: okTitle, style: okStyle, handler: okEventHandler)
            controller.addAction(actionOk)
        }
        if cancelButton {
            let actionCancel = UIAlertAction(title: cancelTitle, style: cancelStyle, handler: cancelEventHandler)
            controller.addAction(actionCancel)
        }
        if let actions = actions {
            for i in actions {
                controller.addAction(i)
            }
        }
        
        if let vc = viewControllerToPresent {
            vc.present(controller, animated: true, completion: completion)
        } else if let topViewController = UIViewController.topViewController() {
            topViewController.present(controller, animated: true, completion: nil)
        }
    }
}

extension Alert {
    
    static func show(_ title: String?, _ body: String?) {
        Alert.show(title: title, body: body)
    }
    static func showError(_ body: String?, actions: [UIAlertAction]? = nil) {
        Alert.show(title: "Error".localized, body: body, actions: actions)
    }
    
    static func showError(_ error: Error?, actions: [UIAlertAction]? = nil) {
        return Alert.show(body: error?.localizedDescription ?? "Something went wrong".localized, actions: actions)
    }
    
    static func showErrorNoInternet() {
        return Alert.show(title: "Error".localized, body: "The Internet connection appears to be offline.".localized)
    }
    
    static func showSuccess(body: String?, actions: [UIAlertAction]? = nil) {
        return Alert.show(title: "Success".localized, body: body, actions: actions)
    }
    
    static func settings(_ presentingVC: UIViewController? = nil, title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: {(action: UIAlertAction) -> Void in
            
        })
        let settingsAction = UIAlertAction(title: "Settings".localized, style: .default, handler: {(action: UIAlertAction) -> Void in
            UIApplication.openURLStr(UIApplication.openSettingsURLString)
        })
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        
        if let vc = presentingVC {
            vc.present(alert, animated: true, completion: nil)
        } else if let vc = UIApplication.shared.keyWindow?.rootViewController?.visibleViewController() {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showInputDialog(title: String? = nil, subtitle: String? = nil, actionTitle: String? = "Save", cancelTitle: String? = "Cancel".localized, text: String? = nil, inputPlaceholder: String? = nil, inputKeyboardType: UIKeyboardType = UIKeyboardType.default, cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil, actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.text = text
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
            textField.clearButtonMode = .always
            textField.returnKeyType = .done
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController?.visibleViewController() {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
}



extension UIAlertController {
    
    func addAction(title: String? = nil, style: UIAlertAction.Style = .default, eventHandler: ((_ action: UIAlertAction) -> Void)! = nil) {
        let action = UIAlertAction(title:title, style: style, handler: eventHandler)
        addAction(action)
    }
}
