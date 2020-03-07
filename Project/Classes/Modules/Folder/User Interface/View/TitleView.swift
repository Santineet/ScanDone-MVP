//
//  CountryListHeaderView.swift
//  VPN01
//
//  Created by Igor Bizi, laptop2 on 24/10/2018.
//  Copyright © 2018 Igor Bizi. All rights reserved.
//

import UIKit

enum TitleViewTheme {
    case dark, light
}

class TitleView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func setText(text: String?, theme: TitleViewTheme = .light) {
        var attributes: [NSAttributedString.Key : Any] = [:]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        switch theme {
        case .dark: attributes = [ .paragraphStyle: paragraphStyle, .foregroundColor: UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.5), .font: UIFont._RobotoRegular(12), .kern: 1.2 ]
        case .light: attributes = [ .paragraphStyle: paragraphStyle, .foregroundColor: UIColor.white, .font: UIFont._RobotoMedium(12), .kern: 1.2 ]
        }
        titleLabel.attributedText = .init(string: text ?? " ", attributes: attributes)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setText(text: nil)
//        titleLabel.font = UIFont._LatoRegular(14)
//        titleLabel.textColor = UIColor.black.alpha(0.4)
//        titleLabel.text = TitleView.text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    
}
