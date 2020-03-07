//
//  CancelAnytimeCell.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 3/11/17.
//  Copyright © 2017 BEST. All rights reserved.
//

import UIKit


class SubscriptionTitleCell: UITableViewCell {
    static let reuseIdentifier = "SubscriptionTitleCell"
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var constraint_imageView1_height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        removeSeparatorInset()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.37
        paragraphStyle.alignment = .center
        titleLabel.attributedText = NSMutableAttributedString(string: "Activate Your Free \n 3-Day Trial".localized().uppercased(), attributes: [ NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.foregroundColor : UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 1), NSAttributedString.Key.font : UIFont._RobotoRegular(20), .kern: 2 ])
        
        switch Density.value {
        case .group0, .group1:
            constraint_imageView1_height.constant = 110
        default: break
        }
        reload()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
