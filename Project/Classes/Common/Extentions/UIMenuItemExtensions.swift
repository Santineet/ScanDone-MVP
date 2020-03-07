//
//  UIMenuItemExtensions.swift
//  Project
//
//  Created by Shane Gao on 2019/8/4.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

extension UIMenuItem {
    convenience init(menu: FolderItemCellMenu) {
        self.init(title: menu.title.localized, action: menu.action)
    }
}
