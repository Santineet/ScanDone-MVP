//
//  PreviewViewController.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class PreviewViewController: UIViewController {
    
    var eventHandler: PreviewModuleInterface!
    var push = true
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraint_collectionView_bottom: NSLayoutConstraint!

    var initialIndexPath = IndexPath.init(item: 0, section: 0)
    var didScrollToInitialIndexPath = false
    
    deinit {
    }
    
    lazy var horizontalMenuUserInterface: HorizontalMenuViewController = {
        let wireframe = HorizontalMenuWireframe()
        wireframe.presenter.delegate = self
        wireframe.userInterface.dataSource = [.delete, .edit, .more]
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
extension PreviewViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeBackBarButtonTitle()
        view.backgroundColor = UIColor.hexColor("444444")
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(UINib(nibName: PreviewItemCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PreviewItemCell.reuseIdentifier)
                
        addChild(horizontalMenuUserInterface, childView: horizontalMenuView, superview: horizontalMenuContainerView)
        horizontalMenuView.reload()
        
        constraint_collectionView_bottom.constant = horizontalMenuView.frame.height
        view.reload()
     
        collectionView.collectionViewLayout = PreviewLayout()
        
        eventHandler.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
}


extension PreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventHandler.delegate?.item.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let folder = eventHandler.delegate?.item else { return UICollectionViewCell() }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewItemCell.reuseIdentifier, for: indexPath) as! PreviewItemCell
        let url = folder.files[indexPath.row].path.url
        cell.imageView1.sd_setImage(with: url, placeholderImage: R.image.documentLoading())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !didScrollToInitialIndexPath {
            collectionView.scrollToItem(at: initialIndexPath, at: .centeredVertically, animated: false)
            reloadNavigationTitle(initialIndexPath)
            didScrollToInitialIndexPath = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for indexPath in collectionView.indexPathsForVisibleItems {
            reloadNavigationTitle(indexPath)
        }
    }
}


//EVENTS
extension PreviewViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    @objc func exportButtonAction() {
        eventHandler.didSelectShare()
    }
    
    @objc func editButtonAction() {
        eventHandler.didSelectEdit()
    }
    
    @objc func deleteButtonAction() {
        eventHandler.didSelectDelete()
    }
    
}


//METHODS
extension PreviewViewController {
    
    func visibleIndexPath() -> IndexPath? {
        return collectionView.indexPathsForVisibleItems.first
    }
    
    func visibleCell() -> PreviewItemCell? {
        return collectionView.visibleCells.first as? PreviewItemCell
    }
}


extension PreviewViewController: PreviewViewInterface {
    
    func reloadData() {
        if let view = collectionView {
            view.reloadData()
        }
    }
    
    func reloadNavigationTitleForVisibleItem() {
        let indexPath = collectionView.indexPathsForVisibleItems.first ?? initialIndexPath
        reloadNavigationTitle(indexPath)
    }
    
    func reloadNavigationTitle(_ indexPath: IndexPath) {
        let title = "%@ of %@".localizedFormat(String(indexPath.row+1), String(collectionView.numberOfItems(inSection: 0))).uppercased()
        setAttributedTitle(title)
    }

}

/// Selector
fileprivate extension Selector {
    static let editButtonAction = #selector(PreviewViewController.editButtonAction)
    static let exportButtonAction = #selector(PreviewViewController.exportButtonAction)
    static let deleteButtonAction = #selector(PreviewViewController.deleteButtonAction)
}


extension PreviewViewController: HorizontalMenuDelegate {
    func moduleHorizontalMenu_didSelect(_ item: HorizontalMenuItem) {
        switch item {
        case .delete:
            eventHandler.didSelectDelete()
        case .edit:
            eventHandler.didSelectEdit()
        case .more:
            eventHandler.didSelectMore()
        default: break
        }
    }
}

