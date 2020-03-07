//
//  NoContentView.swift
//  BreatheTrainer
//
//  Created by IgorBizi@mail.ru on 8/13/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit

class NoContentView: UIView {
    static var color = UIColor.black
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var type = NoContentViewType.none {
        didSet {
            update()
        }
    }
    
    func update() {
        titleLabel.text = type.title
        bodyLabel.text = type.body
        setNeedsLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        update()
        
        backgroundColor = UIColor.clear
        titleLabel.textColor = NoContentView.color
        titleLabel.font = UIFont._regular(21)
        bodyLabel.textColor = NoContentView.color.withAlphaComponent(0.7)
        bodyLabel.font = UIFont._regular(17)
    }
    
    func show(_ show: Bool) {
        isHidden = !show
    }
    
    static func create(_ type: NoContentViewType, superview: UIView, color: UIColor = NoContentView.color) -> NoContentView {
        for i in superview.subviews {
            if i is NoContentView {
                i.removeFromSuperview()
            }
        }
        let view = NoContentView.loadFromNib("NoContentView")
        view.type = type
        superview.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalTo(superview.bounds.width*0.1)
            make.trailing.equalTo(-superview.bounds.width*0.1)
        }
        view.show(false)
        view.titleLabel.textColor = color
        view.bodyLabel.textColor = color.withAlphaComponent(0.7)
        return view
    }
    
}
