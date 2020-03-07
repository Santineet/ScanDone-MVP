//
//  HorizontalMenuItems.swift
//  Project
//
//  Created by Shane Gao on 2019/8/21.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import Foundation

enum HorizontalMenuItem {
    case camera, about, menu, select, edit, addPhoto, delete, more, close, empty, export, copy, language, copied, ocr, filters, back
    
    var title: String? {
        switch self {
        case .camera: return "CAMERA".localized()
        case .about: return "ABOUT".localized()
        case .menu: return "MENU".localized()
        case .select: return "SELECT".localized()
        case .edit: return "EDIT".localized()
        case .addPhoto: return "ADD PHOTO".localized()
        case .delete: return "DELETE".localized()
        case .more: return "MORE".localized()
        case .close: return "CLOSE".localized()
        case .empty: return nil
        case .export: return "EXPORT".localized()
        case .copy: return "COPY ALL".localized()
        case .language: return "LANGUAGE".localized()
        case .copied: return "COPIED".localized()
        case .ocr: return "OCR".localized()
        case .filters: return "FILTERS".localized()
        case .back: return "BACK".localized()
        }
    }
    
    var image: UIImage? {
        switch self {
        case .camera: return R.image.horizontalMenuItemCamera()
        case .about: return R.image.horizontalMenuItemAbout()
        case .menu: return R.image.horizontalMenuItemMenu()
        case .select: return R.image.horizontalMenuItemSelect()
        case .edit: return R.image.horizontalMenuItemEdit()
        case .addPhoto: return R.image.horizontalMenuItemAddCamera()
        case .delete: return R.image.horizontalMenuItemDelete()
        case .more: return R.image.horizontalMenuItemMore()
        case .close: return R.image.horizontalMenuItemClose()
        case .empty: return nil
        case .export: return R.image.horizontalMenuItemExport()
        case .copy: return R.image.horizontalMenuItemCopy()
        case .language: return R.image.horizontalMenuItemLanguage()
        case .copied: return R.image.horizontalMenuItemCopied()
        case .ocr: return R.image.horizontalMenuItemOcr()
        case .filters: return R.image.horizontalMenuItemFilters()
        case .back: return R.image.horizontalMenuItemBack()
        }
    }
}
