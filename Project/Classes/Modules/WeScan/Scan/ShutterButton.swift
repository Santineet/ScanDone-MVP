//
//  ShutterButton.swift
//  WeScan
//
//  Created by Boris Emorine on 2/26/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

enum ShutterButtonType {
    case start, restart, done
}

class ShutterButton: UIButton {
    
    var state_: ShutterButtonType = .start {
        didSet {
            update(state_)
        }
    }
    
    func update(_ type: ShutterButtonType) {
        switch type {
        case .start: setImage(UIImage(named: "camera-start"), for: .normal)
        case .restart: setImage(UIImage(named: "camera-restart"), for: .normal)
        case .done: setImage(UIImage(named: "camera-done"), for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        update(.start)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
