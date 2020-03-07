//
//  NetworkManager.swift
//  MusicPlayer
//
//  Created by IgorBizi@mail.ru on 4/15/18.
//  Copyright © 2018 IgorBizi@mail.ru. All rights reserved.
//

import Foundation


extension NetworkManager {
    
    func logAnalytics(_ type: AnalyticsEvent, completion: ((_ error: Error?) -> Void)! = nil) {
        guard App.enableAnalytics else { return }
        
        let url = URL(string: NetworkManager.domain + "track")!
        var parameters = NetworkManager.parameters()
        parameters["event"] = type.key
        switch type {
        case .shutdown:
//            parameters["vpn_geo"] = VPNManager.shared.selectedVPNID
            parameters["user_geo"] = Locale.current.regionCode ?? ""
        default: break
        }
        NetworkManager.shared.sessionManager?.request(url, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response: DataResponse) in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [String : AnyObject] {
                    print("\nlogAnalytics response \(type.key) : \(json)")
                    if completion != nil {
                        completion(nil)
                    }
                } else {
                    if completion != nil {
                        completion(NSError.somethingWentWrong())
                    }
                }
                break
                
            case .failure(let error):
                print(error)
                if completion != nil {
                    completion(error)
                }
                break
            }
        }
        
        
        
    }
 
}
