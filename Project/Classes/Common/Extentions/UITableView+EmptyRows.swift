//
//  UITableView+EmptyRows.swift
//  100500
//
//  Created by IgorBizi@mail.ru on 6/18/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit

protocol UITableViewFromNibLoading {}

extension UIViewController : UITableViewFromNibLoading {}

//extension UITableViewFromNibLoading where Self : UIViewController {

extension UIViewController {
    @objc func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    @objc func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    @objc func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    @objc func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
