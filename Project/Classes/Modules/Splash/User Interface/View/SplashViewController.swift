//
//  SplashViewController.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit
import SwiftyGif

class SplashViewController: UIViewController {

    var eventHandler: SplashModuleInterface!
    var push = true

    deinit {
        
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var processLabel: UILabel!
}


//LIFECYCLE
extension SplashViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        eventHandler.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventHandler.viewWillAppear()
    }
    
}

//EVENTS
extension SplashViewController {
    
}

extension SplashViewController: SplashViewInterface {
    func reloadData() {
        
    }
   
}

//METHODS
extension SplashViewController {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        setupGifViews()
        processLabel
            .align(.center)
            .font(._RobotoRegular(12))
            .textColor(UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 1))
            .text("LOADING...".localized)
    }
    
    private func setupGifViews() {
        let gifName = R.image.launchScreenLogoAnimatedGif.name
        let gif = UIImage(gifName: gifName)
        imageView.setGifImage(gif)
        imageView.loopCount = 1
        imageView.delegate = self
        imageView.startAnimatingGif()
    }
}

extension SplashViewController: SwiftyGifDelegate {
    
    func gifDidStop(sender: UIImageView) {
        imageView.delegate = nil
        delay(1) { [weak self] in
            self?.eventHandler.animationDidStop()
        }
    }
}
