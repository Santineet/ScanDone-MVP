//
//  EditViewController.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class EditViewController: UIViewController {
    
    var eventHandler: EditModuleInterface!
    var push = true
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraint_collectionView_bottom: NSLayoutConstraint!

    @IBOutlet weak var deleteButton: UIButton!

    var initialIndexPath = IndexPath.init(item: 0, section: 0)
    var didScrollToInitialIndexPath = false
    
    deinit {
    }
    
    lazy var cancelBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(.init(string: "Cancel".localized.uppercased(), attributes: [ .foregroundColor: UIColor._green3, .font: UIFont._RobotoRegular(12), .kern: 1.2 ]), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    lazy var doneBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(.init(string: "Done".localized.uppercased(), attributes: [ .foregroundColor: UIColor._green3, .font: UIFont._RobotoRegular(12), .kern: 1.2 ]), for: .normal)
        button.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    lazy var horizontalMenuUserInterface: HorizontalMenuViewController = {
        let wireframe = HorizontalMenuWireframe()
        wireframe.presenter.delegate = self
        wireframe.userInterface.dataSource = [.ocr, .addPhoto, .filters]
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
    
    lazy var filterMenuUserInterface: FilterMenuViewController = {
        let wireframe = FilterMenuWireframe()
        wireframe.presenter.delegate = self
        let userInterface = wireframe.userInterface!
        userInterface.view.reload()
        return userInterface
    }()
    
    lazy var filterMenuView: UIView = {
        return filterMenuUserInterface.contentView!
    }()
    
}


//LIFECYCLE
extension EditViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeBackBarButtonTitle()
        addNavBarShadow()
        view.backgroundColor = ._green1
        
        collectionView.register(UINib(nibName: EditItemCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: EditItemCell.reuseIdentifier)

        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        reloadNavigationTitleForVisibleItem()
        
        addChild(horizontalMenuUserInterface, childView: horizontalMenuView, superview: horizontalMenuContainerView)
        horizontalMenuView.reload()
        
        addChild(filterMenuUserInterface, childView: filterMenuView, superview: horizontalMenuContainerView)
        filterMenuView.reload()
        filterMenuView.isHidden = true
        
        constraint_collectionView_bottom.constant = horizontalMenuView.frame.height
        view.reload()
        
        reloadFilterViewForVisibleItem()
        
        eventHandler.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}


extension EditViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return eventHandler.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditItemCell.reuseIdentifier, for: indexPath) as! EditItemCell
        cell.imageView1.image = eventHandler.dataSource[indexPath.section].display
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !didScrollToInitialIndexPath {
            collectionView.scrollToItem(at: initialIndexPath, at: .centeredHorizontally, animated: false)
            reloadNavigationTitle(initialIndexPath)
            reloadFilterView(initialIndexPath)
            didScrollToInitialIndexPath = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset: CGFloat = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.left
        var size = collectionView.bounds.size
        size.width -= inset*2
        return size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for indexPath in collectionView.indexPathsForVisibleItems {
            reloadNavigationTitle(indexPath)
            reloadFilterView(indexPath)
        }
    }
}


//EVENTS
extension EditViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        eventHandler.didSelectDelete()
    }
    
//    @IBAction func imageRecognizerButtonAction(_ sender: Any) {
//        eventHandler.didSelectImageRecognizer()
//    }
    
    @IBAction func cropButtonAction(_ sender: Any) {
        eventHandler.didSelectCrop()
    }
    
    @IBAction func rotateButtonAction(_ sender: Any) {
        visibleCell()?.rotateImageView { [weak self] in
            self?.eventHandler.didSelectRotate()
        }
    }
    
//    @IBAction func addButtonAction(_ sender: Any) {
//        eventHandler.didSelectAdd()
//    }
    
    @objc func cancelButtonAction(_ sender: Any) {
        eventHandler.didSelectCancel()
    }
    
    @objc func doneButtonAction(_ sender: Any) {
        eventHandler.didSelectDone()
    }
    
}


//METHODS
extension EditViewController {
    
    
    func visibleIndexPath() -> IndexPath? {
        return collectionView.indexPathsForVisibleItems.first
    }
    
    func visibleCell() -> EditItemCell? {
        return collectionView.visibleCells.first as? EditItemCell
    }
}


extension EditViewController: EditViewInterface {
    
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
        let count = " " + "(" + "%@ of %@".localizedFormat(String(indexPath.section+1), String(collectionView.numberOfSections)).uppercased() + ")"
        switch eventHandler.type {
        case .create?, .append?:
            setAttributedTitle(title: "Editting".localized.uppercased(), count: count)
        case .edit?:
            setAttributedTitle(title: eventHandler.item?.name, count: count)
        default: break
        }
    }

    func reloadFilterViewForVisibleItem() {
        let indexPath = collectionView.indexPathsForVisibleItems.first ?? initialIndexPath
        reloadFilterView(indexPath)
    }
    
    func reloadFilterView(_ indexPath: IndexPath) {
        let index1 = indexPath.section
        guard index1 >= 0, index1 < eventHandler.dataSource.count, !eventHandler.dataSource.isEmpty else { return }
        let filter = eventHandler.dataSource[index1].filter
        let image = eventHandler.dataSource[index1].display.crop(to: CGSize(width: 70, height: 70))
        filterMenuUserInterface.selected = filter
        filterMenuUserInterface.image = image
        filterMenuUserInterface.reloadData()
    }
}

extension EditViewController: HorizontalMenuDelegate {
    func moduleHorizontalMenu_didSelect(_ item: HorizontalMenuItem) {
        switch item {
        case .ocr:
            eventHandler.didSelectImageRecognizer()
        case .addPhoto:
            eventHandler.didSelectAdd()
        case .filters:
            filterMenuView.isHidden = false
            horizontalMenuView.isHidden = true
        default: break
        }
    }
}

extension EditViewController: FilterMenuDelegate {
    func moduleFilterMenu_didSelect(_ item: FilterMenuItem) {
        switch item {
        case .filter(let filterItem):
            guard let indexPath = visibleIndexPath() else { return }
            eventHandler.didSelectFilter(filterItem, indexPath)
        case .back:
            filterMenuView.isHidden = true
            horizontalMenuView.isHidden = false
        }
    }
}


