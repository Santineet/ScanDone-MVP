//
//  FolderListItemCell.swift
//  100500
//
//  Created by IgorBizi@mail.ru on 6/18/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit

class MoveIntoItemCell: UICollectionViewCell {
        
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var selectionBackgroundView: UIView!
    @IBOutlet weak var checkmarkImageView: UIImageView!

    var name: String? = "" {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            nameLabel.attributedText = .init(string: name ?? "", attributes: [ .paragraphStyle: paragraphStyle, .foregroundColor: UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 1), .font: UIFont._RobotoRegular(12), .kern: 1.2 ])
        }
    }
    
    var count: String? = "" {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            countLabel.attributedText = .init(string: count ?? "", attributes: [ .paragraphStyle: paragraphStyle, .foregroundColor: UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.6), .font: UIFont._RobotoRegular(10), .kern: 1 ])
        }
    }
}

extension MoveIntoItemCell: NibReusable { }

extension MoveIntoItemCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        actionEnabled(false)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionBackgroundView.roundCorners(3)
    }
    
    override var isSelected: Bool {
        didSet {
            checkmarkImageView.image = isSelected ? R.image.imageNavCheckedEnabled() : R.image.imageNavCheckedDisabled()
        }
    }
}

extension MoveIntoItemCell {
     
    override func prepareForReuse() {
        super.prepareForReuse()
        actionEnabled(false)
    }
    
    func actionEnabled(_ flag: Bool) {
        selectionBackgroundView.isHidden = !flag
    }
}

