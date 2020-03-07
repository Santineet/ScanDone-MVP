//
//  BTCheckBoxTableViewCell.swift
//  BreatheTrainer
//
//  Created by IgorBizi@mail.ru on 7/31/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit

class BuySubscriptionCell: UITableViewCell {
    static let reuseIdentifier = "BuySubscriptionCell"

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    lazy var shadowView: ShadowView = {
        let view = ShadowView()
        view.blur = 15
        view.cornerRadius = 0
        view.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08)
        view.shadowOffset = CGSize(width: 0, height: 8)
        view.shadowOpacity = 1
        return view
    }()
    
    var title: String? = "" {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            paragraphStyle.lineHeightMultiple = 1.28
            titleLabel.attributedText = .init(string: title ?? "", attributes: [ .paragraphStyle: paragraphStyle, .foregroundColor: UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 1), .font: UIFont._RobotoRegular(18), .kern: 0.7 ])
        }
    }
    
    //UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.5)
    var subtitle: String? = "" {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .right
            paragraphStyle.lineHeightMultiple = 1.28
            subtitleLabel.attributedText = .init(string: subtitle ?? "", attributes: [ .paragraphStyle: paragraphStyle, .foregroundColor: UIColor._green1, .font: UIFont._RobotoMedium(20), .kern: 1 ])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()

        backgroundColor = .clear
        removeSeparatorInset()
        selectionStyle = .none
        colorView.backgroundColor = .white
        
        contentView.insertSubview(shadowView, belowSubview: colorView)
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(colorView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorView.roundCorners(3)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

