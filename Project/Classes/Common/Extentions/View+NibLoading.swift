//
//  ViewFromNibLoading.swift
//  100500
//
//  Created by IgorBizi@mail.ru on 6/9/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit

protocol ViewFromNibLoading {}

extension UIView : ViewFromNibLoading {}

extension ViewFromNibLoading where Self : UIView {
    
    // note that this method returns an instance of type `Self`, rather than UIView
    static func loadFromNib() -> Self {
        let nibName = "\(self)".split{$0 == "."}.map(String.init).last!
        return loadFromNib(nibName)
    }
    
    static func loadFromNib(_ nibName: String) -> Self {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
}
