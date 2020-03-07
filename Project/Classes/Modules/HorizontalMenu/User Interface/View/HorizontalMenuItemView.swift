//
//  FolderListItemCell.swift
//  100500
//
//  Created by IgorBizi@mail.ru on 6/18/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit

class HorizontalMenuItemView: UIView {
        
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var image: UIImage? = nil {
        didSet {
            iconImageView.image = image
        }
    }
    
    var title: String? = "" {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            titleLabel.attributedText = .init(string: title ?? "", attributes: [ .paragraphStyle: paragraphStyle, .foregroundColor: UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.6), .font: UIFont._RobotoRegular(10), .kern: 1 ])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}


