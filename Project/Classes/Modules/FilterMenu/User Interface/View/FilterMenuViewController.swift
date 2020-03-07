//
//  FilterMenuViewController.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class FilterMenuViewController: UIViewController {
    
    var eventHandler: FilterMenuModuleInterface!
    var push = false
    var dataSource: [FilterItem] = FilterItem.allCases
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var shadowBackgroundView: UIView!
    
    lazy private var shadowView: ShadowView = {
        let view = ShadowView(frame: .zero)
        view.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        view.blur = 20
        view.cornerRadius = 0
        view.shadowOffset = CGSize(width: 0.0, height: -8.0)
        return view
    }()
    
    @IBOutlet weak var backBackgroundView: UIView!
    
    var image: UIImage! = R.image.documentTemp()
    var selected: FilterItem = .original
}


//LIFECYCLE
extension FilterMenuViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        contentView.backgroundColor = .clear
        modalPresentationStyle = .overFullScreen

        collectionView.register(cellType: EmptyCollectionViewCell.self)
        
        contentView.insertSubview(shadowView, belowSubview: shadowBackgroundView)
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(collectionView)
        }
         
        collectionView.backgroundColor = .white
        shadowView.alpha = 1
        
        let view = HorizontalMenuItemView.loadFromNib()
        view.reload()
        backBackgroundView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let item = HorizontalMenuItem.back
        view.title = item.title
        view.image = item.image

        let backGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(backButtonAction))
        view.addGestureRecognizer(backGestureRecognizer)
        
        eventHandler.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
}

extension FilterMenuViewController: FilterMenuViewInterface {
    
    func reloadData() {
        if let view = collectionView {
            view.reloadData()
        }
    }
}

extension FilterMenuViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        for i in cell.contentView.subviews {
            i.removeFromSuperview()
        }
        
        let view = FilterMenuItemView.loadFromNib()
        cell.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let item = dataSource[indexPath.item]
        view.isSelected = item == selected
        view.title = item.title
        view.image = item.apply(image)
        return cell
    }
    
}

extension FilterMenuViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource[indexPath.item]
        selected = item
        eventHandler.didSelect(.filter(_item: item))
        reloadData()
    }
}


extension FilterMenuViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let view = FilterMenuItemView.loadFromNib()
        view.reload()
        let width = UIScreen.main.bounds.width
        let height = view.heightToFit(width)
        return CGSize(width: 85, height: height)
    }
}

//EVENTS

extension FilterMenuViewController {
    
    @objc func backButtonAction() {
        eventHandler.didSelect(.back)
    }
}


//METHODS.
extension FilterMenuViewController {
         
    
}

