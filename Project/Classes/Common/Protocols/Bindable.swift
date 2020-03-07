//
//  Bindable.swift
//  Project
//
//  Created by Shane Gao on 2019/8/2.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

protocol Bindable {
    associatedtype Model
    func bind(to model: Model)
}
