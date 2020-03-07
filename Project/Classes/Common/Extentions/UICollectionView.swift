//
//  UICollectionView.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 4/27/17.
//  Copyright © 2017 BEST. All rights reserved.
//

import Foundation


extension UICollectionView {
//    func indexPathForView(_ view: UIView) -> IndexPath? {
//        let originInCollectioView = self.convert(CGPoint.zero, from: view)
//        return self.indexPathForItem(at: originInCollectioView)
//    }
    
    func indexPathFor(view: UIView) -> IndexPath? {
        if let cell = cellFor(view: view), let indexPath = self.indexPath(for: cell) {
            return indexPath
        }
        return nil
    }
    
    func cellFor(view: UIView) -> UICollectionViewCell? {
        var superView = view.superview
        while superView != nil {
            if superView is UICollectionViewCell {
                return superView as? UICollectionViewCell
            } else {
                superView = superView?.superview
            }
        }
        return nil
    }
    
}

extension UICollectionView {
    
    public func deselectSelectedItems(animated: Bool = true) {
        if let items = indexPathsForSelectedItems {
            items.forEach { deselectItem(at: $0, animated: animated) }
        }
    }
    
    public var currentIndex: Int {
        let contentWidth = collectionViewLayout.collectionViewContentSize.width
        let index = Int(round((min(contentOffset.x, contentWidth) / frame.size.width)))
        return index
    }
    
}
