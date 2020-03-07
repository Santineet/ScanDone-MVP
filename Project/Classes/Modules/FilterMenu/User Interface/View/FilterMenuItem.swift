//
//  FilterMenuItems.swift
//  Project
//
//  Created by Shane Gao on 2019/8/21.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import Foundation

enum FilterMenuItem {
    case back, filter(_item: FilterItem)
    
    var title: String? {
        return nil
    }
    
    var image: UIImage? {
        return nil
    }
}
