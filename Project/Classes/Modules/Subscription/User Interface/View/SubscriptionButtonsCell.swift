//
//  CancelAnytimeCell.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 3/11/17.
//  Copyright © 2017 BEST. All rights reserved.
//

import UIKit


class SubscriptionButtonsCell: UITableViewCell {
    static let reuseIdentifier = "SubscriptionButtonsCell"
    
    @IBOutlet weak var centerButton: SubscriptionButton!
    @IBOutlet weak var rightButton: SubscriptionButton!
    @IBOutlet weak var leftButton: SubscriptionButton!
    @IBOutlet weak var constraint_height_buttonsView: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        removeSeparatorInset()
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
