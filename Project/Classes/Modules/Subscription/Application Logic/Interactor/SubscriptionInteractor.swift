//
//  SubscriptionInteractor.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class SubscriptionInteractor {

    var dataManagerAPI: SubscriptionDataManagerAPI!
    var dataManagerLocal: SubscriptionDataManagerLocal!
    weak var output: SubscriptionInteractorOutput!
    
}


extension SubscriptionInteractor: SubscriptionInteractorInput {
    
    func loadList() {
        weak var weakSelf = self
        dataManagerAPI.loadList { (items, error) in
            DispatchQueue.main.async {
                weakSelf?.output.didLoadList(items, error: error)
            }
//            let q1 = SubscriptionItem.init(product: SKProduct.init())
//            q1.type = .Monthly
//            let q2 = SubscriptionItem.init(product: SKProduct.init())
//            q2.type = .Yearly
//            weakSelf?.output.didLoadList([q1,q2], error: error)
        }
    }
    
    func buy(_ item: SubscriptionItem) {
        weak var weakSelf = self
        dataManagerAPI.buy(item) { (error) in
            DispatchQueue.main.async {
                weakSelf?.output.didBuy(error)
            }
        }
    }
    
    func restore() {
        weak var weakSelf = self
        dataManagerAPI.restore { (error) in
            DispatchQueue.main.async {
                weakSelf?.output.didRestore(error)
            }
        }
    }
    
}


