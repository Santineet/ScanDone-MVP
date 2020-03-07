//
//  SubscriptionDataManagerAPI.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class SubscriptionDataManagerAPI {

    var pageLoading = false
}


extension SubscriptionDataManagerAPI: SubscriptionDataManagerAPIInput {
    
    static func parseProducts(_ items: [SKProduct]) -> [SubscriptionItem] {
        var result = [SubscriptionItem]()
        for i in PurchaseItem.allActivePurchasesRawValues {
            let item = items.filter { $0.productIdentifier == i }.first
            if let item = item {
                result.append(SubscriptionItem(product: item))
            }
        }
        return result
    }
    
    func loadList(_ completion: @escaping ([SubscriptionItem], Error?) -> Void) {
        guard !pageLoading else {
            return
        }
        
        pageLoading = true
        weak var weakSelf = self
        
        InAppPurchaseDataManagerAPI.shared.requestProducts(Set(PurchaseItem.allActivePurchasesRawValues), successBlock:{ (products) in
            
            weakSelf?.pageLoading = false
            completion(SubscriptionDataManagerAPI.parseProducts(products) , nil)
            
            }, failureBlock: { (error) in
                weakSelf?.pageLoading = false
                completion([], error)
        })
    }
    
    func buy(_ item: SubscriptionItem, completion: @escaping (Error?) -> Void) {
        guard !pageLoading else {
            return
        }
        
        pageLoading = true
        weak var weakSelf = self
        
        InAppPurchaseDataManagerAPI.shared.buyProduct(item.product, successBlock: { (transaction) in
            weakSelf?.pageLoading = false
            completion(nil)
            
            }, failureBlock: { (transaction, error) in
                weakSelf?.pageLoading = false
                completion(error)
        })
    }
    
    func restore(_ completion: @escaping (Error?) -> Void) {
        guard !pageLoading else {
            return
        }
        
        pageLoading = true
        weak var weakSelf = self
        
        InAppPurchaseDataManagerAPI.shared.restore({ (transactions) in
            weakSelf?.pageLoading = false
            completion(nil)
            
            }, failureBlock: { (error) in
                weakSelf?.pageLoading = false
                completion(error)
        })
    }
}

