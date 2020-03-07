//
//  UITableViewCell.swift
//  FunnyFeed
//
//  Created by IgorBizi@mail.ru on 7/5/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit

extension UITableViewCell {
    // change tintColor = UIColor.redColor() and call the method
    func prepareDisclosureIndicator() {
        for case let button as UIButton in subviews {
            let image = button.backgroundImage(for: UIControl.State())?.withRenderingMode(.alwaysTemplate)
            button.setBackgroundImage(image, for: UIControl.State())
        }
    }
    
    func setSelectedColor(_ color: UIColor) {
        let bgColorView = UIView()
        bgColorView.backgroundColor = color
        selectedBackgroundView = bgColorView
    }
    
    func removeSeparatorInset() {
        
        if self.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            self.separatorInset = UIEdgeInsets.zero
        }
        
        if self.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            self.preservesSuperviewLayoutMargins = false
        }
        
        if self.responds(to: #selector(setter: UIView.layoutMargins)) {
            self.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func removeSeparator() {
        
        if self.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            self.separatorInset = UIEdgeInsets.init(top: 0, left: UIScreen.main.bounds.height*2, bottom: 0, right: 0);
        }
        
        if self.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            self.preservesSuperviewLayoutMargins = false
        }
        
        if self.responds(to: #selector(setter: UIView.layoutMargins)) {
            self.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func fixIpadClearBackground() {
        self.backgroundColor = self.backgroundColor
    }
    
    func removeSeparators() {
//        if let v = contentView.viewWithTag(2536) {
//            v.removeFromSuperview()
//        }
//        if let v = contentView.viewWithTag(2537) {
//            v.removeFromSuperview()
//        }
//        if let v = contentView.viewWithTag(2538) {
//            v.removeFromSuperview()
//        }
    }
    
    func addBottomSeparator() {
        let tag = 2536
        guard contentView.viewWithTag(tag) == nil else {
            return
        }
        
        let view = UIView()
        view.tag = tag
        view.backgroundColor = UIColor.clear //white.withAlphaComponent(0.25)
        contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(0.5)
        }
        
        //addGradient(view: view)
    }
    
    func addTopSeparator() {
        let tag1 = 2537
//        let tag2 = 2538
        guard contentView.viewWithTag(tag) == nil else {
            return
        }
        
//        let inset: CGFloat = 20
//        let width = (contentView.bounds.width-inset*2)/2
//
//        let colorCorner =  UIColor.white.withAlphaComponent(0)
//        let colorCenter = UIColor.white.withAlphaComponent(0.25)
        
        let view1 = UIView()
        view1.tag = tag1
        view1.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        contentView.addSubview(view1)
        view1.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(0.5)
        }
//        view1.addGradient(angle: 90, firstColor: colorCorner, secondColor: colorCenter)
        
//        let view2 = UIView()
//        view2.tag = tag2
//        view2.backgroundColor = UIColor.clear
//        contentView.addSubview(view1)
//        view2.snp.makeConstraints { (make) in
//            make.top.equalTo(view1)
//            make.leading.equalTo(view1)
//            make.height.equalTo(view1)
//            make.trailing.equalToSuperview().offset(-inset)
//        }
//        view2.addGradient(angle: -90, firstColor: colorCenter, secondColor: colorCorner)
        
    }
    
 
}


