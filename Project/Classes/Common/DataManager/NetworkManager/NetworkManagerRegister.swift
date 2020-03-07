//
//  NetworkManager.swift
//  MusicPlayer
//
//  Created by IgorBizi@mail.ru on 4/15/18.
//  Copyright © 2018 IgorBizi@mail.ru. All rights reserved.
//

import Foundation

class NetworkManagerRegister: NSObject {
    
    #if DF_ON
    var dfDataManager: DFDataManager?
    #endif

    let reachability = try! Reachability()

    override init() {
        super.init()
        
        guard !AppSettings.didRegister else {
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi, .cellular:
            if !AppSettings.didRegister {
                register { (error) in }
            }
        case .none: break
        case .unavailable: break
        }
    }
    
    var pageLoading = false
    
    func register(completion: @escaping (_ error: Error?) -> Void) {
        if pageLoading {
            return
        }
        
        pageLoading = true
        weak var weakSelf = self
        
        let url = URL(string: NetworkManager.domain + "rgs")!
        NetworkManager.shared.sessionManager?.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse) in
            
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [String : AnyObject] {
                    AppSettings.didRegister = true
                    print("\n register: \(json)")
                    
                    if let value = json["uid"] as? String {
                        AppSettings.uId = value
                    }
                    if let value = json["geo"] as? String {
                        AppSettings.uGeo = value
                    }
                    if let value = json["params"] as? String, value == "rev" {
                        AppSettings.shouldReviewApp = true
                    }
                    
                    #if DF_ON
                    DispatchQueue.main.async {  _ = DFDataManager(json: json) }
                    #endif
                    
                    if AppSettings.didRegister {
                        NetworkManager.shared.logAnalytics(.install)
                    }
                    
                    NotificationCenter.default.post(name: .NetworkManagerRegisterDidRegister, object: nil)

                    weakSelf?.pageLoading = false
                    completion(nil)
                } else {
                    weakSelf?.pageLoading = false
                    completion(NSError.somethingWentWrong())
                }
                break
                
            case .failure(let error):
                print(error)
                weakSelf?.pageLoading = false
                completion(error)
                break
            }
        }
    }
}


extension Notification.Name {
    
    static let NetworkManagerRegisterDidRegister = Notification.Name("NetworkManagerRegisterDidRegister")
    
}


