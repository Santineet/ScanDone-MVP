//
//  FolderViewController.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit
import Reusable

class FolderViewController: UIViewController {

    var eventHandler: FolderModuleInterface!
    var push = true

    deinit {
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    lazy private var cancelBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(.init(string: "Cancel".localized.uppercased(), attributes: [ .foregroundColor: UIColor._green3, .font: UIFont._RobotoRegular(12), .kern: 1.2 ]), for: .normal)
        button.tap(self, action: #selector(switchSelection))
        return UIBarButtonItem(customView: button)
    }()
            
    lazy private var longPressGesture: UILongPressGestureRecognizer = {
        let lp = UILongPressGestureRecognizer(target: self, action: .longPress)
        lp.minimumPressDuration = 1
        return lp
    }()
    
    var hasSelected: Bool = false {
        didSet {
        }
    }
    
    var isSelecting: Bool = false {
        didSet {
            reloadTitle()
            
            if !isSelecting {
                collectionView.deselectSelectedItems()
                hasSelected = false
            }
            
            collectionView.backgroundColor = isSelecting ? ._green1 : .clear
            
            reloadData()
            
            
            horizontalMenuUserInterface.dataSource = isSelecting ? [.delete, .more] : [.select, .addPhoto, .edit]
            
            navigationItem.leftBarButtonItem = isSelecting ? cancelBarButtonItem : nil
            navigationItem.hidesBackButton = isSelecting
        }
    }
    
    var selectedIndexPaths: [IndexPath] {
        return collectionView.indexPathsForSelectedItems ?? []
    }
    
    lazy private var navigationTitleButton: UIButton = {
        let button = UIButton()
        button.tap(self, action: #selector(navigationTitleButtonAction))
        navigationItem.titleView = button
        return button
    }()
    
    lazy var horizontalMenuUserInterface: HorizontalMenuViewController = {
        let wireframe = HorizontalMenuWireframe()
        wireframe.presenter.delegate = self
        wireframe.userInterface.dataSource = [.select, .addPhoto, .edit]
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
extension FolderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.rightBarButtonItem = rightNavItem
        
        view.backgroundColor = ._light1
        removeBackBarButtonTitle()
        addNavBarShadow()
        
        isSelecting = false
        hasSelected = false
        
        addChild(horizontalMenuUserInterface, childView: horizontalMenuView, superview: horizontalMenuContainerView)
        horizontalMenuView.reload()
        
        collectionView.allowsMultipleSelection = true
        collectionView.register(cellType: FolderItemCell.self)
        collectionView.register(supplementaryViewType: EmptyCollectionReusableView.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.addGestureRecognizer(longPressGesture)
                
        let layout = FolderLayout()
        var insets = layout.sectionInset
        insets.bottom = horizontalMenuView.frame.height + 20
        layout.sectionInset = insets
        collectionView.collectionViewLayout = layout
        
        reloadHeaderHeight()
        
        eventHandler.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventHandler.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !isSelecting {
            collectionView.deselectSelectedItems()
        }
    }
    
}

extension FolderViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventHandler.item.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        let cell: FolderItemCell = collectionView.dequeueReusableCell(for: indexPath)
        let url = eventHandler.item.files[indexPath.item].path.url
        cell.coverView.sd_setImage(with: url, placeholderImage: R.image.documentLoading())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return !isSelecting
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        eventHandler.didDrag(sourceIndexPath, destinationIndexPath)
    }
}

extension FolderViewController {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let contentView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyCollectionReusableView.reuseIdentifier, for: indexPath) as! EmptyCollectionReusableView
        for i in contentView.subviews {
            if i is TitleView {
                i.removeFromSuperview()
            }
        }
        let view = TitleView.loadFromNib("TitleView")
        view.reload()
        var text = ""
//        if isSelecting {
//            text = "%ld selected".localizedFormat(selectedIndexPaths.count).uppercased()
//
//        } else {
            text = eventHandler.item.count == 1 ? "1 image".localized.uppercased() : "%ld images".localizedFormat(eventHandler.item.count).uppercased()
//        }
        
        view.setText(text: text, theme: isSelecting ? .light : .dark)
        reloadHeaderHeight(text)
        contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        return contentView
    }
    
}


extension FolderViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let waterflow = collectionView.collectionViewLayout as? CHTCollectionViewWaterfallLayout else { return .zero }
        
        let deviceWidth = UIScreen.main.bounds.width
        
        let availabeWidth = deviceWidth
            - CGFloat(waterflow.columnCount - 1) * waterflow.minimumColumnSpacing
            - waterflow.sectionInset.left
            - waterflow.sectionInset.right
        let cellWidth = availabeWidth / CGFloat(waterflow.columnCount)
        let cellHeight = cellWidth / FolderItemCell.aspect
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension FolderViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? FolderItemCell else { return }
        cell.showSelectedView = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSelecting {
            guard let cell = collectionView.cellForItem(at: indexPath) as? FolderItemCell else { return }
            cell.showSelectedView = true
            hasSelected = collectionView.indexPathsForSelectedItems?.count ?? 0 > 0
        } else {
            eventHandler.didSelectItem(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isSelecting {
            hasSelected = collectionView.indexPathsForSelectedItems?.count ?? 0 > 0
        }
    }
}

//EVENTS
extension FolderViewController {
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    @objc func exportButtonAction() {
        eventHandler.didSelectShare(selectedIndexPaths)
    }
    
    @objc func deleteButtonAction() {
        eventHandler.didSelectDelete(selectedIndexPaths)
    }
    
    @objc func addButtonAction() {
        eventHandler.didSelectAdd()
    }
    
    @objc func moveButtonAction() {
        eventHandler.didSelectMove(selectedIndexPaths)
    }
    
    @objc func editButtonAction() {
        eventHandler.didSelectEdit()
    }
    
    @objc func switchSelection() {
        isSelecting = !isSelecting
    }
    
    @objc func navigationTitleButtonAction(_ sender: UIButton) {
        guard !isSelecting else {
            return
        }
        eventHandler.didSelectNavigationTitle()
    }
}

extension FolderViewController: FolderViewInterface {
    func reloadData() {
        collectionView.reloadData()
    }
    
    
    func stopSelection(withDelay: Bool) {
        weak var weakSelf = self
        delay(withDelay ? 1 : 0, closure: {
            weakSelf?.isSelecting = false
        })
    }
}

//METHODS
extension FolderViewController {
    
    func reloadCount() {
        reloadData()
    }
    
    func reloadTitle() {
        var title = ""
        if isSelecting {
            title = "Select documents".localized.uppercased()
        } else {
            title = eventHandler.item.name
        }
        navigationTitleButton.setAttributedTitle(NSAttributedString(string: title, attributes: [ .foregroundColor: UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 1), .font: UIFont._RobotoRegular(12), .kern: 1.2 ]), for: UIControl.State())
        navigationTitleButton.sizeToFit()
    }
    
    func reloadHeaderHeight(_ text: String? = nil) {
        let view = TitleView.loadFromNib("TitleView")
        view.setText(text: text)
        let layout = (collectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout)
        layout.headerHeight = view.heightToFit(UIScreen.main.bounds.width)
        collectionView.collectionViewLayout = layout
    }
}

/// Selector
fileprivate extension Selector {
    static let moveButtonAction = #selector(FolderViewController.moveButtonAction)
    static let editButtonAction = #selector(FolderViewController.editButtonAction)
    static let exportButtonAction = #selector(FolderViewController.exportButtonAction)
    static let addButtonAction = #selector(FolderViewController.addButtonAction)
    static let deleteButtonAction = #selector(FolderViewController.deleteButtonAction)
//    static let rightNavItemTapped = #selector(FolderViewController.rightNavItemTapped)
    static let longPress = #selector(FolderViewController.handleLongGesture(gesture:))
}


extension FolderViewController: HorizontalMenuDelegate {
    func moduleHorizontalMenu_didSelect(_ item: HorizontalMenuItem) {
        switch item {
        case .select:
            switchSelection()
        case .addPhoto:
            eventHandler.didSelectAdd()
        case .edit:
            eventHandler.didSelectEdit()
        case .delete:
            eventHandler.didSelectDelete(selectedIndexPaths)
        case .more:
            eventHandler.didSelectMore()
        default: break
        }
    }
}

