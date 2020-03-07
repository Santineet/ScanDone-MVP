//
//  Wireframe.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit
import SafariServices


class Wireframe: NSObject, SKStoreProductViewControllerDelegate {

    static func rootViewContollerFromWindow(_ window: UIWindow) -> UIViewController! {
        if window.rootViewController is UINavigationController {
            if let nvc = window.rootViewController as? UINavigationController {
                return nvc.viewControllers.first
            }
            return nil
        } else {
            return window.rootViewController
        }
    }
    
    //MARK: Create ViewControllers
    
    
//    static func createViewController(withKey key: String) -> UIViewController {
//        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        let viewController = storyboard.instantiateViewControllerWithIdentifier(key)
//        return viewController
//    }
    
    static func createViewController(withKey key: String, storyboard: StoryboardName? = StoryboardName.Main) -> UIViewController {
        return createViewController(withKey: key, storyboardName: storyboard!.rawValue)
    }
    
    static func createViewController(withKey key: String, storyboardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: key)
        return viewController
    }
    
    static func createViewController(withXibName xibName: String) -> UIViewController {
        return Bundle.main.loadNibNamed(xibName, owner: nil, options: nil)!.first as! UIViewController
    }
    
    
    //MARK: WireframeInput
    
    var presentedVC: UIViewController? {
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            presentedVC = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController
        }
        return presentedVC
    }

    static func presentShareInterface(_ vc: UIViewController?, _ sourceView: UIView? = nil, _ sourceRect: CGRect? = nil, _ barButtonItem: UIBarButtonItem? = nil, activityItems: [AnyObject], completionCanceled: (() -> Void)! = nil, completionCompleted: (() -> Void)!) {
        
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if Density.isPad {
            activityController.popoverPresentationController?.sourceView = sourceView
        }
        if Density.isPad, let view = sourceView {
            activityController.popoverPresentationController?.sourceRect = CGRect(x: view.frame.size.width/2, y: view.frame.size.height/2, width: 1, height: 1)
        }
        if Density.isPad {
            activityController.popoverPresentationController?.barButtonItem = barButtonItem
        }
        if let vc = vc {
            vc.present(activityController, animated: true, completion: nil)
            activityController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
                if (!completed) {
                    if completionCanceled != nil {
                        completionCanceled()
                    }
                }
                if completionCompleted != nil {
                    completionCompleted()
                }
            }
        }
    }
    
    func presentITunesProductsInterface(_ identifier: String) {
        if let _: AnyClass = NSClassFromString("SKStoreProductViewController") {
            weak var weakSelf = self
            let storeViewController = SKStoreProductViewController()
            storeViewController.delegate = self
            let parameters = [SKStoreProductParameterITunesItemIdentifier : identifier]
            storeViewController.loadProduct(withParameters: parameters) { (loaded, error) -> Void in
                if let vc = weakSelf?.presentedVC {
                    vc.present(storeViewController, animated: true, completion: nil)
                }
        }
            
        } else {
            UIApplication.shared.open(URL(string:"itms://itunes.apple.com/artist/id" + identifier)!)
        }
    }
    
    //MARK: SKStoreProductViewControllerDelegate
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    static func openSettings() {
        UIApplication.shared.open(
            URL(string: UIApplication.openSettingsURLString)!
        )
    }
    
    func presentSafariInterface(_ presenting: UIViewController?, url: URL?) {
        guard let url = url else {
            return
        }
        if let presenting = presenting {
            //UIApplication.shared.statusBarStyle = .default
            let safariViewController = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            safariViewController.delegate = self
//            if !Density.isPhone {
//                UIApplication.statusBar(show: false)
//            }
            presenting.present(safariViewController, animated: true, completion: nil)
        }
    }
}



extension Wireframe: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
//        UIApplication.statusBar(show: true)
    }
}

// MARK: MFMailComposeViewControllerDelegate

extension Wireframe: MFMailComposeViewControllerDelegate {
    
    func presentMailInterface(recipients: [String]?, subject: String?, body: String?) {
        
        if MFMailComposeViewController.canSendMail() {
            let bgColor = UIColor.hexColor("F5F4F7")
            UINavigationBar.appearance().backgroundColor = bgColor
            let font = UIFont.systemFont(ofSize: 17)
            let textColor = UIColor.hexColor("007AFF")
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor: textColor], for: .normal)
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : textColor], for: .highlighted)
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : textColor], for: .selected)
            
            delay(0.1, closure: {
                
                let controller = MFMailComposeViewController()
                controller.mailComposeDelegate = self
                if let recipients = recipients {
                    controller.setToRecipients(recipients)
                }
                if let subject = subject {
                    controller.setSubject(subject)
                }
                if let body = body {
                    controller.setMessageBody(body, isHTML: false)
                }
                weak var weakSelf = self
                if let userInterface = weakSelf?.presentedVC {
                    //                    controller.hero.isEnabled = true
                    //                    controller.hero.modalAnimationType = .selectBy(presenting: HeroDefaultAnimationType.slide(direction: .up), dismissing: HeroDefaultAnimationType.slide(direction: .down))
                    controller.modalPresentationStyle = .fullScreen
                    userInterface.present(controller, animated: true, completion:  { () in
                        UIApplication.statusBarBackgroundColor(.clear)
                        UIApplication.shared.statusBarStyle = .default
                    })
                }
            })
        } else {
            if let vc = presentedVC {
                let alert = UIAlertController(title: "Could Not Send Email".localized, message: "Your device could not send e-mail. Please check e-mail configuration and try again.".localized, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: {(action: UIAlertAction) -> Void in
                    
                })
                let settingsAction = UIAlertAction(title: "Settings".localized, style: .default, handler: {(action: UIAlertAction) -> Void in
                    
                    let url = URL(string:UIApplication.openSettingsURLString)!
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                })
                alert.addAction(cancelAction)
                alert.addAction(settingsAction)
                
                vc.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        AppTheme.applyTheme()
        controller.dismiss(animated: true, completion: nil)
    }
}
