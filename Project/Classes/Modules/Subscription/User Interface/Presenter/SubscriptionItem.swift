//
//  SubscriptionItem.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 8/25/16.
//  Copyright © 2016 BEST. All rights reserved.
//

import UIKit
import StoreKit


class SubscriptionItem: Equatable {
    static func == (lhs: SubscriptionItem, rhs: SubscriptionItem) -> Bool {
        return lhs.product.productIdentifier == rhs.product.productIdentifier
    }
    
    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        return formatter
    }()
    
    var type = PurchaseItem.None
    
    let product: SKProduct
    
    var price: NSDecimalNumber {
        return product.price
    }
    
    var priceAndCurrency: String {
        SubscriptionItem.formatter.locale = product.priceLocale
        return "\(SubscriptionItem.formatter.string(from: price)!)"
    }
    
    var currencySymbol: String {
        if let s = (product.priceLocale as NSLocale).object(forKey: NSLocale.Key.currencySymbol) as? String {
            return s
        } else {
            return ""
        }
    }
    
    var isCurrencySymbolBeforePrice: Bool {
        let currencyFormat = CFNumberFormatterGetFormat(CFNumberFormatterCreate(nil, product.priceLocale as CFLocale, .currencyStyle)) as NSString
        let positiveNumberFormat = currencyFormat.components(separatedBy: ";")[0] as NSString
        let currencySymbolLocation = positiveNumberFormat.range(of: "¤").location
        return (currencySymbolLocation == 0) ? true : false
    }
    
    init() {
        self.product = SKProduct()
    }
    
    init(product: SKProduct) {
        self.product = product
        if let type = PurchaseItem(rawValue: product.productIdentifier) {
            self.type = type
        }
    }
    
    func currentPriceForDisplayStr() -> String {
        if isCurrencySymbolBeforePrice {
            return currencySymbol + String(describing: self.price)
        } else {
            return String(describing: self.price) + currencySymbol
        }
    }

    
}
