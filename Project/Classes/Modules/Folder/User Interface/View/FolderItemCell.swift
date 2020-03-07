//
//  FolderItemCell.swift
//  100500
//
//  Created by IgorBizi@mail.ru on 6/18/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit
import SDWebImage

class FolderItemCell: UICollectionViewCell {
    
    public static let aspect: CGFloat = 105 / 140
    
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet private weak var checkedView: UIImageView!
    
    public var showSelectedView: Bool = false {
        didSet {
            layer.borderColor = (showSelectedView ? UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.15) : UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.15)).cgColor
            layer.borderWidth = 1.0
            layer.cornerRadius = 4
            checkedView.isHidden = !showSelectedView
        }
    }
}

extension FolderItemCell: NibReusable { }

extension FolderItemCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showSelectedView = false
    }
    
    override var isSelected: Bool {
        didSet {
            if !isSelected {
                showSelectedView = false
            }
        }
    }
}
