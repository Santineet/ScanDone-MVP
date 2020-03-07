//
//  OnboardingViewCell.swift
//  VPN01
//
//  Created by Shane Gao on 2019/8/14.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit
import SwiftyGif

class OnboardingViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
}

extension OnboardingViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

extension OnboardingViewCell: NibReusable { }

extension OnboardingViewCell {
    
    public func configure(with model: Onboarding) {
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        titleParagraphStyle.lineBreakMode = .byWordWrapping
        
        titleLabel.attributedText = .init(
            string: model.title,
            attributes: [
                .paragraphStyle: titleParagraphStyle,
                .foregroundColor: UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 1),
                .font: UIFont._RobotoMedium(18),
                .kern: 1.8
            ]
        )
        
        let subtitleParagraphStyle = NSMutableParagraphStyle()
        subtitleParagraphStyle.alignment = .center
        subtitleParagraphStyle.lineBreakMode = .byWordWrapping
        subtitleParagraphStyle.lineHeightMultiple = 1.37
        subtitleLabel.attributedText = .init(
            string: model.subtitle,
            attributes: [
                .paragraphStyle: subtitleParagraphStyle,
                .foregroundColor: UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 1),
                .font: UIFont._RobotoRegular(18)
            ]
        )
        
        iconView.setGifImage(model.image)
        iconView.loopCount = 1
        iconView.startAnimatingGif()

    }
    
    public static var reuseIdentifier: String {
        return String(describing: OnboardingViewCell.self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}

extension OnboardingViewCell {
    
    private func setupViews() {
        
    }
}
