//
//  UIBarButtonItemExtensions.swift
//  Project
//
//  Created by Shane Gao on 2019/8/9.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    public func button(title: String?) {
        guard let button = customView as? UIButton else { return }
        button.title(title)
        button.sizeToFit()
    }
}
