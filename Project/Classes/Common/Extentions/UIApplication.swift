//
//  UIApplication.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 3/8/17.
//  Copyright © 2017 BEST. All rights reserved.
//

import UIKit

extension UIApplication {
    
    private var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            return nil
        } else {
            return value(forKey: "statusBar") as? UIView
        }
    }
    
    static func statusBarBackgroundColor(_ color: UIColor?) {
        UIApplication.shared.statusBarView?.backgroundColor = color
    }
    
    static func statusBar(show: Bool) {
        UIApplication.shared.isStatusBarHidden = !show
    }
    
    static func statusBar(style: UIStatusBarStyle) {
        UIApplication.shared.statusBarStyle = style
    }
    
    static func disableScreenLightOffAutomaticaly(_ flag: Bool) {
        UIApplication.shared.isIdleTimerDisabled = flag
    }
    
    static func openURLStr(_ urlStr: String?) {
        if let urlStr = urlStr {
            openURL(URL(string: urlStr))
        }
    }
    
    static func openURL(_ url: URL?) {
        if let url = url {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
