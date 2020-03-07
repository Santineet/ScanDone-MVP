//
//  BTCheckBoxTableViewCell.swift
//  BreatheTrainer
//
//  Created by IgorBizi@mail.ru on 7/31/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit

class SettingsItemCell: UITableViewCell {
    static let reuseIdentifier = "SettingsItemCell"

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
        
        removeSeparatorInset()
        
        backgroundColor = .clear
        setSelectedColor(UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.05))
        
        titleLabel.text = nil
        titleLabel.font = ._RobotoRegular(14)
        titleLabel.textColor = ._gray5
    }
    
}
