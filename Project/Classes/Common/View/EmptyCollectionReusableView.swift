//
//  GMHeaderCV.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 4/27/18.
//  Copyright © 2018 BEST. All rights reserved.
//

import Foundation

class EmptyCollectionReusableView: UICollectionReusableView {
    
    static let reuseIdentifier = "EmptyCollectionReusableView"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension EmptyCollectionReusableView: NibReusable { }

