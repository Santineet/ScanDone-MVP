//
//  UIViewController.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 11/25/16.
//  Copyright © 2016 BEST. All rights reserved.
//

import Foundation


extension UIViewController {
    
    static func topViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        if let vc = topMostViewController?.visibleViewController() {
            return vc
        }
        return topMostViewController
    }
    
}

extension UIViewController {
    
    var isVisibleAndOnTop: Bool {
        return isViewLoaded == true && self.view.window != nil
    }
    
    func makeTransparentNavigationBar(_ flag: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = flag ? UIColor.clear : UINavigationBar.appearance().backgroundColor
        navigationController?.view.backgroundColor = .clear
    }
    
    func removeBackBarButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action:nil)
    }
    
    func setBackBarButtonTitle(_ title: String) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action:nil)
    }
    
    func setBackBarButtonDefault() {
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor._green3, .font: UIFont._RobotoRegular(12), .kern: 1.8 ] as [NSAttributedString.Key : Any]
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Back".localized().uppercased(), attributes: attributes)
        navigationItem.backBarButtonItem = UIBarButtonItem(customView: label)
    }
    
    func addNavBarShadow() {
        self.navigationController?.navigationBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 20.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    func removeNavBarShadow() {
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 0.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    func showBackButton(_ flag: Bool) {
        navigationItem.setHidesBackButton(!flag, animated: false)
    }
    
    func removeCloseButton() {
        navigationItem.leftBarButtonItem = nil
    }
    
    func isPresentedModally() -> Bool {
        guard let vc = navigationController?.viewControllers.first, vc == self else {
            return false
        }
        return true
    }
    
    func addShadowForNavigationBar(_ flag: Bool) {
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1, height: 1)
        navigationController?.navigationBar.layer.shadowRadius = 2
        navigationController?.navigationBar.layer.shadowOpacity = flag ? 0.3 : 0
    }
    
    func dismissModalStack(animated: Bool, completion: (() -> Void)?) {
        let fullscreenSnapshot = UIApplication.shared.delegate?.window??.snapshotView(afterScreenUpdates: false)
        if !isBeingDismissed {
            var rootVc = presentingViewController
            while rootVc?.presentingViewController != nil {
                rootVc = rootVc?.presentingViewController
            }
            let secondToLastVc = rootVc?.presentedViewController
            if fullscreenSnapshot != nil {
                secondToLastVc?.view.addSubview(fullscreenSnapshot!)
            }
 
            secondToLastVc?.dismiss(animated: false, completion: {
                if rootVc?.presentedViewController == nil {
                    if let completion = completion {
                        completion()
                    }
                } else {
                    rootVc?.dismiss(animated: animated, completion: completion)
                }
            })
        } else {
            weak var weakSelf = self
            delay(1, closure: {
                weakSelf?.dismissModalStack(animated: animated, completion: completion)
            })
        }
    }
    
    func removeFromParentVC() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func addChild(_ childVC: UIViewController?) {
        addChild(childVC, topSafeArea: false)
    }
    
    func addChild(_ childVC: UIViewController?, topSafeArea: Bool = false, topInset: CGFloat = 0) {
        childVC?.removeFromParentVC()
        
        if let childVC = childVC {
            addChild(childVC)
            view.addSubview(childVC.view)
            childVC.view.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                if topSafeArea {
                    if #available(iOS 11, *) {
                        make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).inset(topInset)
                    } else {
                        make.top.equalTo(self.view).inset(UIApplication.shared.statusBarFrame.height).inset(topInset)
                    }
                } else {
                    make.top.equalToSuperview().inset(topInset)
                }
            }
            childVC.didMove(toParent: self)
        }
    }
    
    func addChild(_ childVC: UIViewController?, childView: UIView, superview: UIView) {
        addChild(childVC, childView: childView, superview: superview, topSafeArea: false)
    }
    
    func addChild(_ childVC: UIViewController?, childView: UIView, superview: UIView, topSafeArea: Bool) {
        childVC?.removeFromParentVC()
        
        if let childVC = childVC {
            addChild(childVC)
            superview.addSubview(childView)
            childView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                if topSafeArea {
                    if #available(iOS 11, *) {
                        make.top.equalTo(superview.safeAreaLayoutGuide.snp.topMargin)
                    } else {
                        make.top.equalTo(superview).inset(UIApplication.shared.statusBarFrame.height)
                    }
                } else {
                    make.top.equalToSuperview()
                }
            }
            childVC.didMove(toParent: self)
        }
    }
    
    static func hideTopAlertControllers(completion : (() -> Void)?) {
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController?.visibleViewController() as? UIAlertController {
            topViewController.dismiss(animated: false, completion: completion)
        } else {
            if let completion = completion {
                completion()
            }
        }
    }
    
    static func hideTopAlertControllers() {
        hideTopAlertControllers(completion: nil)
    }
    
    func visibleViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController()
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController()
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController()
        } else {
            return self
        }
    }
    
    func showBigNavTitle(_ flag: Bool) {
        if #available(iOS 11.0, *) {
            if flag {
                navigationController?.navigationBar.prefersLargeTitles = true
                navigationController?.navigationItem.largeTitleDisplayMode = .never
                navigationController?.navigationItem.largeTitleDisplayMode = .automatic
            } else {
                navigationController?.navigationBar.prefersLargeTitles = false
                navigationController?.navigationItem.largeTitleDisplayMode = .never
            }
        }
    }
    
    func navigationBlurTag() -> Int { return 432 }
    
    func addNavigationBlur(color: UIColor?) {
        // Find size for blur effect.
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let bounds = navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -(statusBarHeight)).offsetBy(dx: 0, dy: -(statusBarHeight))
        // Create blur effect.
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.tag = navigationBlurTag()
        if let color = color {
            visualEffectView.backgroundColor = color
        }
        //visualEffectView.alpha = 0.5
        visualEffectView.frame = bounds ?? CGRect.zero
        // Set navigation bar up.
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.view.addSubview(visualEffectView)
//        navigationController?.view.insertSubview(visualEffectView, at: 0)
        let superview = navigationController?.navigationBar
        if superview?.viewWithTag(navigationBlurTag()) == nil {
            if let superview = superview {
                superview.addSubview(visualEffectView)
            }
        }
        if let superview = superview {
            superview.sendSubviewToBack(visualEffectView)
        }
       
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.view.backgroundColor = .clear
    }
    
//    func addCloseButton(target: ) {
//        push = false
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close-icon"), style: .plain, target: self, action: #selector(closeButtonAction(_:)))
//    }
}
