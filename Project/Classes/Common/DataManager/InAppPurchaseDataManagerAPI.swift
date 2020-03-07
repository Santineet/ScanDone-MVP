//
//  InApp1PurchaseDataManagerAPI.swift
//  FunnyFeed
//
//  Created by IgorBizi@mail.ru on 7/4/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit
import StoreKit


class InAppPurchaseDataManagerAPI: NSObject {
    
    static let shared = InAppPurchaseDataManagerAPI()
    
    var myKeySecretApp = "4d2d59022e0c406ead6b4d84b1934bf2"
    fileprivate override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    } //This prevents others from using the default '()' initializer for this class.
    
    let reachability = try! Reachability()
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi, .cellular:
            if AppSettings.didRegister {
                if let validUntilDate = InAppPurchaseDataManagerAPI.validUntilDate, validUntilDate > Date() {
                    //valid
                } else {
                    if AppSettings.uId != nil {
                        InAppPurchaseDataManagerAPI.shared.purchaseCheck()
                    }
                }
            }
        case .none: break
        case .unavailable: break
        }
    }
    
    var savedProducts: [SKProduct]?
    static var enableCaching = false
    static var isValidationInProgress = false
    static var isAboutToMakePurchase = false
    
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    //var purchasedProductIdentifiers: Set<String> = []
    var productsRequest: SKProductsRequest?
    var productsRequestCompletionHandler: (successBlock:(_ products: [SKProduct]) -> Void, failureBlock: (_ error: Error?) -> Void)?
    var buyRequestCompletionHandler: (successBlock: (_ transaction: SKPaymentTransaction?) -> Void, failureBlock: (_ transaction: SKPaymentTransaction?, _ error: Error?) -> Void)?
    var restoreRequestCompletionHandler: (successBlock: (_ transactions: [SKPaymentTransaction]?) -> Void, failureBlock: (_ error: Error?) -> Void)?
    let productIdentifiers = Set(PurchaseItem.allActivePurchasesRawValues)
    
    private static let kValidUntilKey = "InAppPurchaseDataManagerAPI-validUntil"
    static var validUntil: TimeInterval? {
        get {
            if let v = UserDefaults.standard.value(forKey: kValidUntilKey) as? TimeInterval {
                return v
            }
            return nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kValidUntilKey)
        }
    }
    
    static var validUntilDate: Date? {
        get {
            if var validUntil = InAppPurchaseDataManagerAPI.validUntil, validUntil > 0 {
                validUntil /= 1000
                return Date(timeIntervalSince1970: validUntil)
            }
            return nil
        }
    }
    
    static func isActive() -> Bool {
        if App.unlockPremium == true {
            return true
        }
        
        if isValidationInProgress {
            return true
        }
        
        let validUntil = InAppPurchaseDataManagerAPI.validUntil
        print("validUntil: \(String(describing: validUntil))")
        if let validUntilDate = InAppPurchaseDataManagerAPI.validUntilDate {
            print("date      : \(Date()))")
            print("validUntil: \(String(describing: validUntilDate))")
            return validUntilDate > Date()
        } else {
            return false
        }
    }
    
    static func receipt() -> String? {
        let appStoreReceiptURL = Bundle.main.appStoreReceiptURL!
        if FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            var receiptData: NSData?
            do {
                receiptData = try NSData(contentsOf: appStoreReceiptURL, options: NSData.ReadingOptions.alwaysMapped)
            } catch {
                print("ERROR: " + error.localizedDescription)
            }
            if let string = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) {
                return string
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func setup() {
        SKPaymentQueue.default().add(self)
    }
    
    func purchaseCheck() {
        print("checking...")
        weak var weakSelf = self
        receiptValidation(secretKey: myKeySecretApp) { (validUntil, error) in
            if let validUntil = validUntil, error == nil {
                InAppPurchaseDataManagerAPI.validUntil = validUntil
            }
            weakSelf?.deliverPurchaseNotification()
        }
    }
    
    func requestProducts(_ productIdentifiers: Set<String>, successBlock:@escaping (_ products: [SKProduct]) -> Void, failureBlock:@escaping (_ error: Error?) -> Void) {
        if let saved = savedProducts, !saved.isEmpty, InAppPurchaseDataManagerAPI.enableCaching {
            successBlock(saved)
        } else {
            productsRequest?.cancel()
            productsRequestCompletionHandler = (successBlock, failureBlock)
            productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
            productsRequest!.delegate = self
            productsRequest!.start()
        }
    }
    
    func buyProduct(_ product: SKProduct, successBlock: @escaping (_ transaction: SKPaymentTransaction?) -> Void, failureBlock:@escaping (_ transaction: SKPaymentTransaction?, _ error: Error?) -> Void) {
        if canMakePayments() {
            InAppPurchaseDataManagerAPI.isAboutToMakePurchase = true
            print("Buying \(product.productIdentifier)...")
            buyRequestCompletionHandler = (successBlock, failureBlock)
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            failureBlock(nil, errorPaymentsDisabled)
        }
    }
    
    func restore(_ successBlock: @escaping (_ transactions: [SKPaymentTransaction]?) -> Void, failureBlock: @escaping (_ error: Error?) -> Void) {
        if canMakePayments() {
            restoreRequestCompletionHandler = (successBlock, failureBlock)
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            failureBlock(errorPaymentsDisabled)
        }
    }
    
    var errorPaymentsDisabled: NSError {
        let userInfo: [AnyHashable: Any] = [
            NSLocalizedDescriptionKey :  NSLocalizedString("Payments Disabled", value: "Please turn on Payments in your Settings", comment: ""),
            NSLocalizedFailureReasonErrorKey : NSLocalizedString("Payments Disabled", value: "Payments Disabled", comment: "")
        ]
        return NSError(domain: "HttpResponseErrorDomain", code: 401, userInfo: userInfo as? [String : Any])
    }
}


extension InAppPurchaseDataManagerAPI: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        if InAppPurchaseDataManagerAPI.enableCaching {
            savedProducts = response.products
        }
        if let productsRequestCompletionHandler = productsRequestCompletionHandler {
            if !products.isEmpty {
                productsRequestCompletionHandler.successBlock(products)
            } else {
                productsRequestCompletionHandler.failureBlock(NSError.somethingWentWrong())
            }
        }
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
        clearRequestAndHandler()
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        //productsRequestCompletionHandler?(false, nil)
        if let productsRequestCompletionHandler = productsRequestCompletionHandler {
            productsRequestCompletionHandler.failureBlock(error)
        }
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}


extension InAppPurchaseDataManagerAPI: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completed(transaction: transaction)
                break
            case .failed:
                failed(transaction: transaction)
                break
            case .restored:
                restored(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    private func completed(transaction: SKPaymentTransaction) {
        print("complete...")
        if InAppPurchaseDataManagerAPI.isAboutToMakePurchase {
            InAppPurchaseDataManagerAPI.isValidationInProgress = true
        }
        InAppPurchaseDataManagerAPI.isAboutToMakePurchase = false
        buyRequestCompletionHandler?.successBlock(nil)
        buyRequestCompletionHandler = nil
        deliverPurchaseNotification()
        
        receiptValidation(secretKey: myKeySecretApp) { (validUntil, error) in
            if let validUntil = validUntil, error == nil {
                InAppPurchaseDataManagerAPI.validUntil = validUntil
                SKPaymentQueue.default().finishTransaction(transaction)
                let _ = InAppPurchaseDataManagerAPI.isActive()
            }
        }

    }
    
    private func restored(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        print("restore... \(productIdentifier)")
        weak var weakSelf = self
        
        receiptValidation(secretKey: myKeySecretApp) { (validUntil, error) in
            if let validUntil = validUntil, error == nil {
                print(validUntil)
                InAppPurchaseDataManagerAPI.validUntil = validUntil
                weakSelf?.restoreRequestCompletionHandler?.successBlock(nil)
                weakSelf?.restoreRequestCompletionHandler = nil
                weakSelf?.deliverPurchaseNotification()
                SKPaymentQueue.default().finishTransaction(transaction)
                let _ = InAppPurchaseDataManagerAPI.isActive()
            }
        }
//
//        NetworkManager.shared.purchaseBuy { (validUntil, error) in
//            if let validUntil = validUntil, error == nil {
//                print(validUntil)
//                InAppPurchaseDataManagerAPI.validUntil = validUntil
//                weakSelf?.restoreRequestCompletionHandler?.successBlock(nil)
//                weakSelf?.restoreRequestCompletionHandler = nil
//                weakSelf?.deliverPurchaseNotification()
//                SKPaymentQueue.default().finishTransaction(transaction)
//                let _ = InAppPurchaseDataManagerAPI.isActive()
//            }
//        }
    }
    
    private func failed(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        
        if restoreRequestCompletionHandler != nil, buyRequestCompletionHandler != nil {
        } else if restoreRequestCompletionHandler != nil {
            restoreRequestCompletionHandler?.failureBlock(transaction.error)
            restoreRequestCompletionHandler = nil
        } else if buyRequestCompletionHandler != nil {
            buyRequestCompletionHandler?.failureBlock(nil, transaction.error)
            buyRequestCompletionHandler = nil
        }
        InAppPurchaseDataManagerAPI.isAboutToMakePurchase = false
        InAppPurchaseDataManagerAPI.isValidationInProgress = false
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func deliverPurchaseNotification() {
        NotificationCenter.default.post(name: .InAppPurchaseDataManagerDidBuy, object: nil)
    }
            
    func receiptValidation(secretKey: String, completion: ((_ validUntil: TimeInterval?, _ error: Error?) -> Void)! = nil) {
        
        let verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
     
//        #if DEBUG
//        let verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
//        #else
//        let verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"
//        #endif
        
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject, "password" : secretKey as AnyObject]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
                
                if let data = data {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        print("=",jsonResponse)
                        if let date = self?.getExpirationDateFromResponse(jsonResponse as! NSDictionary) {
                            
                            let validUntil = date.millisecondsSince1970
                            print(date.millisecondsSince1970)
                            
                            completion(validUntil, nil)
                            //                        InAppPurchaseDataManagerAPI.validUntil = date.millisecondsSince1970
                        }
                    } catch let parseError {
                        print(parseError)
                        completion(nil, parseError)
                    }
                } else {
                    completion(nil, error)
                }
            })
            task.resume()
        } catch let parseError {
            print(parseError)
        }
    }
    
    
     func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
         
         if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
             
             let lastReceipt = receiptInfo.lastObject as! NSDictionary
             let formatter = DateFormatter()
             formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
             
             if let expiresDate = lastReceipt["expires_date"] as? String {
                 return formatter.date(from: expiresDate)
             }
             return nil
         }
         else {
             return nil
         }
     }
}


extension Error {
    
    static func somethingWentWrong() -> Error {
        return NSError(domain: "Error".localized, code: 401, userInfo: [NSLocalizedDescriptionKey : "Something went wrong".localized])
    }
}


extension Notification.Name {
    
    static let InAppPurchaseDataManagerDidBuy = Notification.Name("InAppPurchaseDataManagerDidBuy")
}


/*
 deinit {
 NotificationCenter.default.removeObserver(self, name: .InAppPurchaseDataManagerDidBuy, object: nil)
 }
 }
 
 extension ScanResultsPresenter: ScanResultsModuleInterface {
 
 func viewDidLoad() {
 NotificationCenter.default.addObserver(self, selector: #selector(InAppPurchaseDataManagerDidBuy), name: .InAppPurchaseDataManagerDidBuy, object: nil)
 
 @objc func InAppPurchaseDataManagerDidBuy() {
 
 }
 
 */

extension Date {
var millisecondsSince1970: TimeInterval {
    return TimeInterval((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
