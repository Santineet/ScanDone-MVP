//
//  UITableView.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 4/10/18.
//  Copyright © 2018 BEST. All rights reserved.
//

import UIKit

extension UINavigationController {
    open func pushViewControllers(_ inViewControllers: [UIViewController], animated: Bool) {
        var stack = self.viewControllers
        stack.append(contentsOf: inViewControllers)
        self.setViewControllers(stack, animated: animated)
    }
}
