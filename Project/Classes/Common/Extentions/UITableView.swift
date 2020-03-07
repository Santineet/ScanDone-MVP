//
//  UITableView.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 4/10/18.
//  Copyright © 2018 BEST. All rights reserved.
//

import UIKit

extension UITableView {
//    func indexPathForView(_ view: UIView) -> IndexPath? {
//        let originInTableView = self.convert(CGPoint.zero, from: view)
//        return self.indexPathForRow(at: originInTableView)
//    }
    
    func indexPathFor(view: UIView) -> IndexPath? {
        if let cell = cellFor(view: view), let indexPath = self.indexPath(for: cell) {
            return indexPath
        }
        return nil
    }
    
    func cellFor(view: UIView) -> UITableViewCell? {        
        var superView = view.superview
        while superView != nil {
            if superView is UITableViewCell {
                return superView as? UITableViewCell
            } else {
                superView = superView?.superview
            }
        }
        return nil
    }
}

extension UITableView {
    
    func sizeHeaderToFit() {
        if let headerView = tableHeaderView {
            var frame = headerView.frame
            frame.size.width = bounds.size.width
            headerView.frame = frame
            headerView.reload()

            frame = headerView.frame
            frame.size.height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            headerView.frame = frame

            self.tableHeaderView = headerView
        }
    }
    
}
