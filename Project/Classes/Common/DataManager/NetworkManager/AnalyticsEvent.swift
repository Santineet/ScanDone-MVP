
//
//  AnalyticsEvent.swift
//  Project
//
//  Created by Igor Bizi, laptop2 on 08/11/2018.
//  Copyright © 2018 Igor Bizi. All rights reserved.
//

import UIKit

enum AnalyticsEvent {
    case install, trialStart, churn, connect, reviewTap, timeout, screenshot, recording, shutdown
    
    var key: String {
        switch self {
        case .install:
            return "APP_INSTALL"
        case .trialStart:
            return "TRIAL_START"
        case .churn:
            return "CHURN"
        case .connect:
            return "CONNECT"
        case .reviewTap:
            return "TAP_REVIEW"
        case .timeout:
            return "TIMEOUT"
        case .screenshot:
            return "SCREENSHOT"
        case .recording:
            return "RECORDING"
        case .shutdown:
            return "SHUTDOWN_VPN"
        }
    }
}
