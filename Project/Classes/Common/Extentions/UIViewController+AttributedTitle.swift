//
//  UITableView.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 4/10/18.
//  Copyright © 2018 BEST. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setAttributedTitle(_ title: String?) {
        let titleLabel = UILabel()
        titleLabel.attributedText = NSMutableAttributedString(string: title ?? "", attributes: [ .foregroundColor: UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 1), .font: UIFont._RobotoRegular(12), .kern: 1.2 ])
        self.navigationItem.titleView = titleLabel
    }
    
    func setAttributedTitle(title: String?, count: String) {
        let titleLabel = UILabel()
        let titleString = NSMutableAttributedString(string: title ?? "", attributes: [ .foregroundColor: UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 1), .font: UIFont._RobotoRegular(12), .kern: 1.2 ])
        let countString = NSAttributedString(string: count, attributes: [ .foregroundColor: UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.5), .font: UIFont._RobotoRegular(12), .kern: 1.2 ])
        titleString.append(countString)
        titleLabel.attributedText = titleString
        self.navigationItem.titleView = titleLabel
    }
}
