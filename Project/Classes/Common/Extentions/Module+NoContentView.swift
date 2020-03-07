//
//  Module+NoContentView.swift
//  100500
//
//  Created by IgorBizi@mail.ru on 6/21/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit

protocol NoContentViewProtocol {
    //for presenter and userInterface
    func showNoContent(_ show: Bool)
    //call from userInterface
    func showNoContent(_ show: Bool, noContentView: UIView!)
}

extension UIViewController : NoContentViewProtocol {}

extension NoContentViewProtocol where Self : UIViewController {
    
    func showNoContent(_ show: Bool) {
    }
    
    func showNoContent(_ show: Bool, noContentView: UIView!) {
        func remove(_ noContentView: UIView!) {
            noContentView.removeFromSuperview()
        }
        
        if show {
            if !noContentView.isDescendant(of: view) {
                var y = view.center.y
                if let navBarHeight = navigationController?.navigationBar.bounds.size.height {
                    y -= navBarHeight
                }
                if let tabBarHeight = tabBarController?.tabBar.bounds.size.height {
                    y -= tabBarHeight
                }
                noContentView.center = CGPoint(x: view.center.x, y: y)
                view.addSubview(noContentView)
            } else {
                //remove(noContentView)
            }
        } else {
            remove(noContentView)
        }
    }
}
