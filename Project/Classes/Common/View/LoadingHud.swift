//
//  Module+LoadingHud.swift
//  100500
//
//  Created by IgorBizi@mail.ru on 6/21/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit
import SnapKit

class LoadingHud: UIView {
    static var color = UIColor.black
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicatorView.color = LoadingHud.color
        
        textLabel.font = UIFont._regular(14)
        textLabel.textColor = LoadingHud.color
        textLabel.text = nil
        
        tag = 4524659
    }
    
}


extension UIView {
    
    func showLoadingHud(_ show: Bool, color: UIColor = LoadingHud.color, text: String? = nil, onSuperview: Bool = false, style: UIActivityIndicatorView.Style = .whiteLarge, backgroundColor: UIColor? = nil) {
        func removeHub() {
            func remove(_ view: LoadingHud) {
                if view.backgroundColor != .clear {
                    UIView.animate(withDuration: 0.3, animations: {
                        view.backgroundColor = .clear
                        view.activityIndicatorView.alpha = 0
                    }, completion: { (_) in
                        view.removeFromSuperview()
                    })
                } else {
                    view.removeFromSuperview()
                }
            }
            
            for i in subviews {
                if let i = i as? LoadingHud {
                    remove(i)
                }
            }
            if onSuperview == true, let superview = superview {
                for i in superview.subviews {
                    if let i = i as? LoadingHud {
                        remove(i)
                    }
                }
            }
        }
        
        removeHub()
        
        if show {
            let view = LoadingHud.loadFromNib("LoadingHud")
            view.activityIndicatorView.style = style
            view.activityIndicatorView.color = color
            view.textLabel.text = text
            view.textLabel.textColor = color
            if backgroundColor != nil {
                addSubview(view)
                view.snp.remakeConstraints({ (make) in
                    make.leading.trailing.bottom.top.equalToSuperview()
                })
                UIView.animate(withDuration: 0.3) {
                    view.backgroundColor = backgroundColor
                }
                bringSubviewToFront(view)
                view.activityIndicatorView.snp.remakeConstraints({ (make) in
                    make.center.equalToSuperview()
                })
            } else if onSuperview, let superview = self.superview {
                superview.addSubview(view)
                view.snp.remakeConstraints({ (make) in
                    make.center.equalTo(self.snp.center)
                })
                superview.bringSubviewToFront(view)
            } else {
                addSubview(view)
                view.snp.remakeConstraints({ (make) in
                    make.center.equalToSuperview()
                })
                bringSubviewToFront(view)
            }
        }
    }
    
}



protocol LoadingHudProtocol {
    func showLoadingHud(_ show: Bool)
    func showLoadingHud(_ show: Bool, parentView: UIView!)
}

extension UIViewController : LoadingHudProtocol {}

extension LoadingHudProtocol where Self : UIViewController {
    
    func showLoadingHud(_ show: Bool, parentView: UIView!) {
        showLoadingHud(show, parentView: parentView, color: LoadingHud.color)
    }
    
    func showLoadingHud(_ show: Bool, parentView: UIView!, color: UIColor) {
        DispatchQueue.main.async { [weak self] in
            func removeHub() {
                for i in parentView.subviews {
                    if i.tag == self?.getTag() {
                        i.removeFromSuperview()
                    }
                }
            }
            
            removeHub()
            
            if show {
                if let hud = self?.loadingHud(color) {
                    self?.view.addSubview(hud)
                    hud.snp.remakeConstraints({ (make) in
                        make.center.equalToSuperview()
                    })
                    self?.view.bringSubviewToFront(hud)
                }
            }
        }
    }
    
    func showLoadingHud(_ show: Bool, color: UIColor) {
        showLoadingHud(show, parentView: view, color: color)
    }
    
    func showLoadingHud(_ show: Bool) {
        showLoadingHud(show, parentView: view)
    }
    
    func loadingHud(_ color: UIColor) -> UIActivityIndicatorView  {
        let view = UIActivityIndicatorView()
        view.style = .whiteLarge
        view.hidesWhenStopped = true
        view.color = color
        view.startAnimating()
        view.tag = getTag()
        return view
    }
    
    func getTag() -> Int {
        return 4524
    }
}
