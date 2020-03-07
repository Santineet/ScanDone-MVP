//
//  FolderListItemCell.swift
//  100500
//
//  Created by IgorBizi@mail.ru on 6/18/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit

class FilterMenuItemView: UIView {
        
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionView: UIView!
    
    var isSelected: Bool = false {
        didSet {
            selectionView.isHidden = !isSelected
            iconImageView.layer.borderColor = isSelected ? UIColor._green1.cgColor : UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.1).cgColor
            iconImageView.layer.borderWidth = isSelected ? 2 : 1
        }
    }
    
    var image: UIImage? = nil {
        didSet {
            iconImageView.image = image
        }
    }
    
    var title: String? = "" {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            titleLabel.attributedText = .init(string: title ?? "", attributes: [ .paragraphStyle: paragraphStyle, .foregroundColor: isSelected ? ._green1 : UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.6), .font: UIFont._RobotoRegular(10), .kern: 1 ])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionView.backgroundColor = ._green1
        isSelected = false
        
        iconImageView.layer.cornerRadius = 5
        iconImageView.clipsToBounds = true

    }
}


