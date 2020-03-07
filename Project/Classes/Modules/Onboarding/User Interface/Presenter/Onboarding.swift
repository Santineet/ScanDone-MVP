//
//  Onboarding.swift
//  VPN01
//
//  Created by Shane Gao on 2019/8/14.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import Foundation

enum Onboarding: CaseIterable {
    case scanAI, edit, export
}

extension Onboarding {
    var title: String {
        switch self {
        case .scanAI:
            return "Business Scan AI".localized.uppercased()
        case .edit:
            return "One-tap editing".localized.uppercased()
        case .export:
            return "Easy file export".localized.uppercased()
        }
    }
    
    var subtitle: String {
        switch self {
        case .scanAI:
            return "The app takes 3 pictures and AI combines them for better quality.".localized
        case .edit:
            return "You can crop, use filters or enable text recognition on a photo with one tap".localized
        case .export:
            return "You can save files as PDF, PNG, JPEG or TXT".localized
        }
    }
    
    var image: UIImage {
        var name = ""
        switch self {
        case .scanAI:
            name = R.image.onboardingScanAiGif.name
        case .edit:
            name = R.image.onboardingEditGif.name
        case .export:
            name = R.image.onboardingExportGif.name
        }
        return UIImage(gifName: name)
    }
}
