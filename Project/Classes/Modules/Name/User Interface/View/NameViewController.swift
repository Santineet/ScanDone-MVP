//
//  NameViewController.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class NameViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomPaddingConstraint: KeyboardLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UIStackView!
    @IBOutlet weak var constraint_contentView_height: NSLayoutConstraint!
    
    var eventHandler: NameModuleInterface!
    var push = false
    
}


//LIFECYCLE
extension NameViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        removeBackBarButtonTitle()
        view.backgroundColor = UIColor.clear
//        cancelButton.setTitle("Cancel".localized, for: .normal)
//        cancelButton.setTitleColor(._green1, for: .normal)
//        cancelButton.titleLabel?.font = ._LatoRegular(18)
        
        
//        let cancelStringFont = UIFont._RobotoRegular(12)
//        let cancelTextString = NSMutableAttributedString(string: "Cancel".localized().uppercased(), attributes: [ NSAttributedString.Key.foregroundColor : UIColor._green3, NSAttributedString.Key.font : cancelStringFont, .kern: 1.2 ])
//        let iconImage = UIImage(named: "nav-close")!
//        let icon = NSTextAttachment()
//        icon.bounds = CGRect(x: 0, y: (cancelStringFont.capHeight - iconImage.size.height).rounded() / 2, width: iconImage.size.width, height: iconImage.size.height)
//        icon.image = iconImage
//        let cancelIconString = NSAttributedString(attachment: icon)
//        let cancelString = NSMutableAttributedString.init(attributedString: cancelIconString)
//        cancelString.append(cancelTextString)
        
        
        cancelButton.setAttributedTitle(NSMutableAttributedString(string: "Cancel".localized().uppercased(), attributes: [ NSAttributedString.Key.foregroundColor : UIColor._green3, NSAttributedString.Key.font : UIFont._RobotoRegular(12), .kern: 1.2 ]), for: .normal)
//        doneButton.setTitle("Done".localized, for: .normal)
//        doneButton.setTitleColor(._green1, for: .normal)
//        doneButton.titleLabel?.font = ._LatoRegular(18)
        doneButton.setAttributedTitle(NSMutableAttributedString(string: "Done".localized().uppercased(), attributes: [ NSAttributedString.Key.foregroundColor : UIColor._green3, NSAttributedString.Key.font : UIFont._RobotoRegular(12), .kern: 1.2 ]), for: .normal)

//        titleLabel.text = "Document name".localized
//        titleLabel.font = ._LatoRegular(18)
//        titleLabel.textColor = .black
        titleLabel.attributedText = NSMutableAttributedString(string: "Document name".localized().uppercased(), attributes: [ NSAttributedString.Key.foregroundColor : UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 1), NSAttributedString.Key.font : UIFont._RobotoRegular(12), .kern: 1.2 ])
        
        textField.textColor = UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 1)
        textField.font = ._RobotoRegular(14)
        textField.tintColor = ._green1
        
        let backgroundClickGesture = UITapGestureRecognizer.init(target: self, action: #selector(backgroundClickAction))
        view.addGestureRecognizer(backgroundClickGesture)
        
        bottomPaddingConstraint.initialOffset = -constraint_contentView_height.constant
        
        eventHandler.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateAppearance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
                 
    }
    
}


//EVENTS
extension NameViewController {
    
    
    @objc func backgroundClickAction(_ sender: Any) {
        eventHandler.didSelectClose()
    }
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        eventHandler.didSelectClose()
    }
    
    @IBAction func doneButtonTouched(_ sender: Any) {
        eventHandler.didSelectDone()
    }
}


//METHODS.
extension NameViewController {
    
    func animationDuration() -> Double { return 0.5 }
    
    func animateAppearance(_ completion: (() -> Void)! = nil) {
        delay(0.1) { [weak self] in
            self?.textField.becomeFirstResponder()
        }
        UIView.animate(withDuration: animationDuration(), animations: { [weak self] in
            self?.view.backgroundColor = UIColor.hexColor("040F0F").withAlphaComponent(0.75)
            }, completion: { (completed) in
        })
    }
    
    func animateDisappearance(_ completion: (() -> Void)! = nil) {
        textField.resignFirstResponder()
        UIView.animate(withDuration: animationDuration(), animations: { [weak self] in
            self?.view.backgroundColor = UIColor.clear
            }, completion: { (_) in
                completion()
        })
    }
    
}


extension NameViewController: NameViewInterface {
    
    
}

extension NameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eventHandler.didSelectDone()
        return false
    }
}

