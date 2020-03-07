//
//  ImageScannerController.swift
//  WeScan
//
//  Created by Boris Emorine on 2/12/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import SPPermission

class ScanPermissionPresenter: NSObject {
    
    static let shared = ScanPermissionPresenter()

    func isAllowed() -> Bool {
        guard SPPermission.isAllowed(.camera) && SPPermission.isAllowed(.photoLibrary) else {
            SPPermission.Dialog.request(with: [.camera, .photoLibrary], on: UIViewController.topViewController() ?? UIViewController(), dataSource: self)
            return false
        }
        return true
    }
}

extension ScanPermissionPresenter: SPPermissionDialogDataSource, SPPermissionDialogColorSource {
    
    var showCloseButton: Bool {
        return true
    }
    
    func name(for permission: SPPermissionType) -> String? {
        switch permission {
        case .camera: return "Camera".localized
        case .photoLibrary: return "Photo Library".localized
        default: return nil
        }
    }
    
    func description(for permission: SPPermissionType) -> String? {
        switch permission {
        case .camera: return "Scan documents by Camera".localized
        case .photoLibrary: return "Import documents from Photo Library".localized
        default: return nil
        }
    }
    
    var dialogTitle: String { return "Need Permissions".localized }
    var dialogSubtitle: String { return "Permissions Request".localized.uppercased() }
    var allowTitle: String { return "Allow".localized.uppercased() }
    var allowedTitle: String { return "Allowed".localized.uppercased() }
    var dialogComment: String { return "Permissions are necessary for the correct work of the application and the performance of all functions. Push are not required permissions".localized }
    var cancelTitle: String { return "Cancel".localized }
    var settingsTitle: String { return "Settings".localized }
    func deniedTitle(for permission: SPPermissionType) -> String? { return "Permission denied".localized }
    func deniedSubtitle(for permission: SPPermissionType) -> String? { return "Please, go to Settings and allow permissions".localized }
    
    func image(for permission: SPPermissionType) -> UIImage? {
        switch permission {
        case .camera: return R.image.permissionCamera()?.overlay(color: ._green1)
        case .photoLibrary: return R.image.permissionPhotoLibrary()?.overlay(color: ._green1)
        default: return nil
        }
    }
    
    var closeIconColor: UIColor { return ._green1 }
    var baseColor: UIColor { return ._green1 }

}
