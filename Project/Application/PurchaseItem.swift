//
//  InAppPurchaseDataManagerLocal.swift
//  FunnyFeed
//
//  Created by IgorBizi@mail.ru on 7/4/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import UIKit

enum PurchaseItem: String {
  
    case None = "None"
    case Weekly = "scan_done_sub_01_week"
    case Monthly = "scan_done_sub_01_month"
    case Monthly3 = "scan_done_sub_01_3month"

    static let allActivePurchasesRawValues = [Monthly3.rawValue, Monthly.rawValue, Weekly.rawValue,  ]
    static let allAutoRenewableRawValues = [Monthly.rawValue, Weekly.rawValue, Monthly3.rawValue]
    static let allNonConsumableRawValues = [String]()
    
}

//app id 1489939510
//App-Specific Shared Secret d582d111b3754e03a35eda5d3b4a27ff
