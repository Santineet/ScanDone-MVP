//
//  CancelAnytimeCell.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 3/11/17.
//  Copyright © 2017 BEST. All rights reserved.
//

import UIKit


class AboutCell: UITableViewCell {
    static let reuseIdentifier = "AboutCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        removeSeparatorInset()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.37
        paragraphStyle.alignment = .center
        titleLabel.attributedText = NSMutableAttributedString(string: "ScanDone".localized, attributes: [ NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.foregroundColor : UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 1), NSAttributedString.Key.font : UIFont._RobotoRegular(30)])
        
        subtitleLabel.attributedText = NSMutableAttributedString(string: "We are a SaaS company that provides its own developments on OCR in the form of an application. We are constantly working on improving recognition algorithms and therefore our service is available only by subscription.".localized(), attributes: [ NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.foregroundColor : UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 1), NSAttributedString.Key.font : UIFont._RobotoRegular(18)])

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
