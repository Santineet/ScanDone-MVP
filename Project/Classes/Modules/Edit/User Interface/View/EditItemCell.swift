//
//  BTCheckBoxTableViewCell.swift
//  BreatheTrainer
//
//  Created by IgorBizi@mail.ru on 7/31/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit

class EditItemCell: UICollectionViewCell {
    static let reuseIdentifier = "EditItemCell"

    @IBOutlet weak var imageView1: ZoomableImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()

        backgroundColor = UIColor.clear
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView1.roundCorners(6)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView1.image = nil
    }
}

extension EditItemCell {
    
    public func rotateImageView(_ completed: (() -> Void)?) {
        imageView1.rotate(to: nil, complete: completed)
    }
}
