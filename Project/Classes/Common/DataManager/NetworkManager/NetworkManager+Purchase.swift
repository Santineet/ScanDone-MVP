//
//  NetworkManager.swift
//  MusicPlayer
//
//  Created by IgorBizi@mail.ru on 4/15/18.
//  Copyright © 2018 IgorBizi@mail.ru. All rights reserved.
//

import Foundation


extension NetworkManager {
    
    func purchaseCheck(completion: ((_ validUntil: TimeInterval?, _ error: Error?) -> Void)! = nil) {
        print("purchaseCheck...")

        let url = URL(string: NetworkManager.domain + "check")!
        let parameters = NetworkManager.parameters()
        print(parameters)
        NetworkManager.shared.sessionManager?.request(url, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse) in
            switch(response.result) {
            case .success(_):
                print("\n check: \(String(describing: response.result.value))")
                if let json = response.result.value as? [String : AnyObject], let validUntil = json["valid_until"] as? Double {
                    completion(validUntil, nil)
                } else {
                    if completion != nil {
                        completion(nil, NSError.somethingWentWrong())
                    }
                }
                break
                
            case .failure(let error):
                print(error)
                if completion != nil {
                    completion(nil, error)
                }
                break
            }
        }
    }
 
    func purchaseBuy(completion: ((_ validUntil: TimeInterval?, _ error: Error?) -> Void)! = nil) {
        print("purchaseBuy...")
        
        let url = URL(string: NetworkManager.domain + "purchase")!
        var parameters = NetworkManager.parameters()
        parameters["geo"] = AppSettings.uGeo
        print(parameters)
        
        guard let receipt = InAppPurchaseDataManagerAPI.receipt() else {
            print("Error: can not get receipt")
            if completion != nil {
                completion(nil, NSError.somethingWentWrong())
            }
            return
        }
        
        parameters["receipt"] = receipt
//        print("\n\n\n")
//        print(parameters["receipt"] ?? "")
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //let data = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        var data: Data?
        do {
            data = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            print("ERROR: " + error.localizedDescription)
        }
        guard let data_ = data, let json = NSString(data: data_, encoding: String.Encoding.utf8.rawValue) else {
            if completion != nil {
                completion(nil, NSError.somethingWentWrong())
            }
            return
        }
        request.httpBody = json.data(using: String.Encoding.utf8.rawValue);
        
        NetworkManager.shared.sessionManager?.request(request).responseJSON { (response:DataResponse) in
            switch(response.result) {
            case .success(_):
                print("\n buy: \(String(describing: response.result.value))")
                if let json = response.result.value as? [String : AnyObject], let validUntil = json["valid_until"] as? Double {
                    completion(validUntil, nil)
                } else {
                    if completion != nil {
                        completion(nil, NSError.somethingWentWrong())
                    }
                }
                break
                
            case .failure(let error):
                print(error)
                if completion != nil {
                    completion(nil, error)
                }
                break
            }
        }
    }
}
