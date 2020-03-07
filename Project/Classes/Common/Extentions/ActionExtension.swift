//
//  UIApplication.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 3/8/17.
//  Copyright © 2017 BEST. All rights reserved.
//

import UIKit

class ActionExtension {
    
    static func openAppUrl(_ urlString: String, _ vc: UIViewController) {
        let url = URL(string: urlString)!
        let selectorOpenURL = sel_registerName("openURL:")
        let context = NSExtensionContext()
        context.open(url, completionHandler: nil)
        var responder = vc as UIResponder?
        while (responder != nil){
            if responder?.responds(to: selectorOpenURL) == true{
                let _ = responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }
    }
    
    static func dismiss(_ vc: UIViewController) {
        vc.extensionContext!.completeRequest(returningItems: vc.extensionContext!.inputItems, completionHandler: nil)
    }
    
}
