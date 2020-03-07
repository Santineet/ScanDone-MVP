//
//  UICollectionView+Menu.swift
//  Project
//
//  Created by Shane Gao on 2019/8/4.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import Foundation

// MARK: - FolderMenuAction
public protocol FolderMenuAction {
    func onRename()
    func onDelete()
    func onEdit()
    func onShare()
}

public enum FolderItemCellMenu: CaseIterable {
    case rename, edit, share, delete
    
    var title: String {
        switch self {
        case .rename: return "Rename".localized
        case .edit: return "Edit".localized
        case .share: return "Share".localized
        case .delete: return "Delete".localized
        }
    }
}

extension FolderItemCellMenu {
    public var action: Selector {
        switch self {
        case .rename: return .onRename
        case .edit: return .onEdit
        case .share: return .onShare
        case .delete: return .onDelete
        }
    }
}

public extension Selector {
    static let onRename = #selector(FolderListItemCell.onRename)
    static let onDelete = #selector(FolderListItemCell.onDelete)
    static let onShare = #selector(FolderListItemCell.onShare)
    static let onEdit = #selector(FolderListItemCell.onEdit)
}

// MARK: - CollectionViewShowsMenu

public protocol CollectionViewShowsMenu {
    
}

extension CollectionViewShowsMenu where Self: UICollectionViewCell {
    
    public func performActionToSuperview(_ action: Selector) {
        guard let collectionView = self.superview as? UICollectionView,
            let delegate = collectionView.delegate,
            let indexPath = collectionView.indexPath(for: self) else { return }
        
        delegate.collectionView?(
            collectionView,
            performAction: action,
            forItemAt: indexPath,
            withSender: self
        )
    }
}
