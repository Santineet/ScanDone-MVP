//
//  String.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 8/19/16.
//  Copyright © 2016 BEST. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    convenience init(items: [NSAttributedString]) {
        self.init()
        for i in items {
            append(i)
        }
    }
}
