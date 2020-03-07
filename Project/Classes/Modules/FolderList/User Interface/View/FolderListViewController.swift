//
//  FolderListViewController.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit
import Reusable

class FolderListViewController: UIViewController {
    
    var eventHandler: FolderListModuleInterface!
    var push = true

    deinit {
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var noContentView = EmptyFolderListView.loadFromNib()
    var dataSource: [FolderItem] = []
    
    lazy var horizontalMenuUserInterface: HorizontalMenuViewController = {
        let wireframe = HorizontalMenuWireframe()
        wireframe.presenter.delegate = self
        wireframe.userInterface.dataSource = [.about, .camera, .menu]
        let userInterface = wireframe.userInterface!
        userInterface.view.reload()
        return userInterface
    }()
    
    lazy var horizontalMenuView: UIView = {
        return horizontalMenuUserInterface.contentView!
    }()
    
    lazy var horizontalMenuContainerView: UIView = {
        horizontalMenuUserInterface.collectionView.reload()

        let view = UIView()
        self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            let view = HorizontalMenuItemView.loadFromNib()
            view.reload()
            let height = view.heightToFit(UIScreen.main.bounds.width)
            make.height.equalTo(height + (AppDependencies.appDelegate.window?.safeAreaInsets.bottom ?? 0))
        }
        return view
    }()
    
 
}


//LIFECYCLE
extension FolderListViewController: FolderListViewInterface {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttributedTitle(App.name)
        removeBackBarButtonTitle()
        addNavBarShadow()
        
        collectionView.register(cellType: FolderListItemCell.self)
        
        let items = FolderItemCellMenu.allCases.map(UIMenuItem.init(menu:))
        UIMenuController.shared.menuItems = items
        
        view.backgroundColor = ._light1
        view.addSubview(noContentView)
        noContentView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().inset(-30)
        }
        
        addChild(horizontalMenuUserInterface, childView: horizontalMenuView, superview: horizontalMenuContainerView)
        horizontalMenuView.reload()
        let layout = FolderListLayout()
        var insets = layout.sectionInset
        insets.bottom = horizontalMenuView.frame.height + 20
        layout.sectionInset = insets
        collectionView.collectionViewLayout = layout
                
        
        eventHandler.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        eventHandler.viewWillAppear()
    }
    
}

extension FolderListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FolderListItemCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = dataSource[indexPath.item]
        cell.name = item.name
        cell.count = item.count == 1 ? "1 image".localized.uppercased() : "%ld images".localizedFormat(item.count).uppercased()
        return cell
    }
}

extension FolderListViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return FolderListLayout.size
    }
}

extension FolderListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath
        ) -> Bool {
        if let cell = collectionView.cellForItem(at: indexPath) as? FolderListItemCell {
            cell.actionEnabled(true)
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        collectionView.reloadData()
        eventHandler.didSelectMenu(action, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FolderListItemCell {
            cell.actionEnabled(true)
        }
        eventHandler.didSelect(indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.reloadData()
    }
}

//EVENTS
extension FolderListViewController {
    
    @objc fileprivate func onImportButtonTapped() {
        eventHandler.didSelectImportPhotos()
    }
    
    @objc fileprivate func onNavMenuTapped() {
        eventHandler.didSelectSetting()
    }
}

//METHODS
extension FolderListViewController {
    
    func reloadData() {
        collectionView.reloadData()
        let isEmpty = dataSource.isEmpty
        noContentView.isHidden = !isEmpty
        horizontalMenuUserInterface.theme = isEmpty ? .clear : .regular
    }
}

/// Selector
fileprivate extension Selector {
    static let menuTapped = #selector(FolderListViewController.onNavMenuTapped)
}


extension FolderListViewController: HorizontalMenuDelegate {
    func moduleHorizontalMenu_didSelect(_ item: HorizontalMenuItem) {
        switch item {
        case .about:
            eventHandler.didSelectAbout()
        case .camera:
            eventHandler.didSelectImportPhotos()
        case .menu:
            eventHandler.didSelectSetting()
        default: break
        }
    }
}

