////
////  CancelAnytimeCell.swift
////  Meditation1
////
////  Created by IgorBizi@mail.ru on 3/11/17.
////  Copyright © 2017 BEST. All rights reserved.
////
//
//import UIKit
//
//
class SubscriptionFooterCell: UITableViewCell {
    static let reuseIdentifier = "SubscriptionFooterCell"
    
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
                
        backgroundColor = UIColor.clear
        removeSeparatorInset()
        selectionStyle = .none
        
////        titleLabel.font = UIFont._medium(12)
////        titleLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.45)
//        titleLabel.text = text

        let text = "Payment will be charged to iTunes Account at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable.".localized
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.28
        let attributes = [ NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.foregroundColor : UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 0.4), NSAttributedString.Key.font : UIFont._RobotoRegular(13) ]
        titleLabel.attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        
    }
    
 
}

