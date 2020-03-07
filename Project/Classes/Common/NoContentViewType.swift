//
//  x.swift
//  PageTranslator
//
//  Created by Igor Bizi, laptop2 on 07/01/2019.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

enum NoContentViewType {
    case offline, none, subscription, notFound, imageRecognizer

    var title: String? {
        switch self {
        case .offline: return "The Internet connection appears to be offline.".localized
        case .imageRecognizer: return "Can not recognize text".localized
        default: return nil
        }
    }
    
    var body: String? {
        switch self {
        case .offline: return "Please connect to the Internet and reload the page.".localized
        case .subscription: return "Please purchase a Premium and reload the page.".localized
        case .notFound: return "Not found".localized
        default: return nil
        }
    }
}
