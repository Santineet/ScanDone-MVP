//
//  HorizontalMenuViewController.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class HorizontalMenuViewController: UIViewController {
    
    var eventHandler: HorizontalMenuModuleInterface!
    var push = false
    var dataSource: [HorizontalMenuItem] = [] {
        didSet {
            reloadData()
        }
    }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy private var shadowView: ShadowView = {
        let view = ShadowView(frame: .zero)
        view.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        view.blur = 20
        view.cornerRadius = 0
        view.shadowOffset = CGSize(width: 0.0, height: -8.0)
        return view
    }()
    
    var theme: HorizontalMenuTheme = .regular {
        didSet {
            reloadTheme()
        }
    }
}


//LIFECYCLE
extension HorizontalMenuViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        contentView.backgroundColor = .clear
        modalPresentationStyle = .overFullScreen

        collectionView.register(cellType: EmptyCollectionViewCell.self)
        
        contentView.insertSubview(shadowView, belowSubview: collectionView)
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(collectionView)
        }
         
        reloadTheme()
        
        eventHandler.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
}

extension HorizontalMenuViewController: HorizontalMenuViewInterface {
    
    func reloadData() {
        if let view = collectionView {
            view.reloadData()
        }
    }
}

extension HorizontalMenuViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        for i in cell.contentView.subviews {
            i.removeFromSuperview()
        }
        
        let view = HorizontalMenuItemView.loadFromNib()
        cell.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let item = dataSource[indexPath.item]
        view.title = item.title
        view.image = item.image
        return cell
    }
    
}

extension HorizontalMenuViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        eventHandler.didSelect(dataSource[indexPath.item])
    }
}


extension HorizontalMenuViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let view = HorizontalMenuItemView.loadFromNib()
        view.reload()
        let width = UIScreen.main.bounds.width
        let height = view.heightToFit(width)
        return CGSize(width: width/CGFloat(dataSource.count), height: height)
    }
}

//EVENTS

extension HorizontalMenuViewController {
    
    
}


//METHODS.
extension HorizontalMenuViewController {
         
    func reloadTheme() {
        switch theme {
        case .regular:
            collectionView.backgroundColor = .white
            shadowView.alpha = 1
        case .clear:
            collectionView.backgroundColor = .clear
            shadowView.alpha = 0
        }
    }
}

