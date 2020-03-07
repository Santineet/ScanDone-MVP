//
//  EmptyFolderListView.swift
//  Project
//
//  Created by Shane Gao on 2019/8/2.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit
import Reusable

class EmptyFolderListView: UIView {
    @IBOutlet private weak var tipsLabel: UILabel!
    @IBOutlet private weak var iconView: UIImageView!
}

extension EmptyFolderListView: NibLoadable { }

extension EmptyFolderListView {
    
    private func setupViews() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.54
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping

        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.5),
            .font: UIFont._RobotoRegular(12),
            .paragraphStyle: paragraphStyle,
            .kern: 1.2
        ]
        
        tipsLabel.attributedText = .init(
            string: "OPEN “CAMERA” TO ADD DOCUMENT".localized,
            attributes: attrs
        )
        iconView.image = R.image.iconMainScan()
    }
}

extension EmptyFolderListView {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}





