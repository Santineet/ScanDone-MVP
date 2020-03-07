//
//  MoveViewController.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit
import Reusable

class MoveViewController: UIViewController {
    
    var eventHandler: MoveModuleInterface!
    var push = false

    deinit {
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    public var dataSource: [FolderItem] = []

    lazy private var cancelBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(.init(string: "Cancel".localized.uppercased(), attributes: [ .foregroundColor: UIColor._green3, .font: UIFont._RobotoRegular(12), .kern: 1.2 ]), for: .normal)
        button.tap(self, action: .close)
        return UIBarButtonItem(customView: button)
    }()
    
    lazy private var doneBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(.init(string: "Done".localized.uppercased(), attributes: [ .foregroundColor: UIColor._green3, .font: UIFont._RobotoRegular(12), .kern: 1.2 ]), for: .normal)
        button.tap(self, action: .done)
        return UIBarButtonItem(customView: button)
    }()
}

extension MoveViewController: MoveViewInterface {
    
    func reloadNaviationItems(_ title: String) {
        setAttributedTitle(title)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

//LIFECYCLE
extension MoveViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        collectionView.register(cellType: MoveIntoItemCell.self)
        
        let layout = FolderListLayout()
        collectionView.collectionViewLayout = layout
        
        removeBackBarButtonTitle()
        addNavBarShadow()
        view.backgroundColor = ._light1
        
        eventHandler.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventHandler.viewWillAppear()
    }
    
}

extension MoveViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: MoveIntoItemCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = dataSource[indexPath.row]
        cell.name = item.name
        cell.count = item.count == 1 ? "1 image".localized.uppercased() : "%ld images".localizedFormat(item.count).uppercased()
        cell.isSelected = eventHandler.selectedItem == item
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath)
    -> Bool {
        return eventHandler.canSelect(dataSource[indexPath.row])
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let canSelect = eventHandler.canSelect(dataSource[indexPath.row])
        if let cell = cell as? MoveIntoItemCell {
            cell.checkmarkImageView.alpha = canSelect ? 1 : 0
        }
    }
}

extension MoveViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return FolderListLayout.size
    }
}

extension MoveViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath
    ) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MoveIntoItemCell {
            cell.actionEnabled(true)
            delay(0.1) {
                cell.actionEnabled(false)
            }
        }
        eventHandler.didSelect(dataSource[indexPath.row], indexPath)
    }
}

//EVENTS
extension MoveViewController {
    
    @objc fileprivate func didSelectClose() {
        eventHandler.didSelectClose()
    }
    
    @objc fileprivate func didSelectDone() {
        eventHandler.didSelectDone()
    }
}

//METHODS
extension MoveViewController {
    
    
}

/// Selector
fileprivate extension Selector {
    static let close = #selector(MoveViewController.didSelectClose)
    static let done = #selector(MoveViewController.didSelectDone)
}
