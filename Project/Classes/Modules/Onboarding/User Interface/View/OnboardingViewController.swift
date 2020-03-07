//
//  OnboardingViewController.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit
import Reusable

// MARK: - Properties
class OnboardingViewController: UIViewController {
    
    var eventHandler: OnboardingModuleInterface!
    var push = false
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomContainerview: UIView!
    @IBOutlet weak var pageControl: PageControl!
    @IBOutlet weak var doneButton: UIButton!
    
    var dataSource = Onboarding.allCases
}

// MARK: - LifeCycle
extension OnboardingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeBackBarButtonTitle()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white
        
        setupCollectionView()
        setupPageControl()
        setupBottomViews()
        
        doneButton.backgroundColor = ._green1
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.28
        paragraphStyle.alignment = .center
        let doneButtonTitle = NSAttributedString(string: "Go to app".localized.uppercased(), attributes: [NSAttributedString.Key.kern: 1.4, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: UIFont._RobotoMedium(14), NSAttributedString.Key.foregroundColor: UIColor.white ])
        doneButton.setAttributedTitle(doneButtonTitle, for: .normal)
        
        eventHandler.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !Density.isFrameless {
            UIApplication.statusBar(show: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.statusBar(show: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViews()
    }
}

// MARK: - Events
extension OnboardingViewController {
    
    @objc private func didSelectReadyStart() {
        eventHandler.didReachRightEdge()
    }
}

// MARK: - OnboardingViewInterface
extension OnboardingViewController: OnboardingViewInterface {
    
    func reloadData() {
        collectionView.reloadData()
        pageControl.numberOfPages = dataSource.count
    }
}

// MARK: - UICollectionViewDelegate

extension OnboardingViewController: UICollectionViewDelegate {
    
}

extension OnboardingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: dataSource[indexPath.row])
        return cell
    }

}

extension OnboardingViewController {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            scrollingFinished()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollingFinished()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset: CGFloat = 30.0
        if scrollView.reachRight(offset: offset) {
            eventHandler.didReachRightEdge()
        }
    }
    
    private func scrollingFinished() {
        let index = collectionView.currentIndex
        eventHandler.didScrollToPageAtIndex(index)
        pageControl.currentPage = index
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        eventHandler.didSelectDone()
    }
}

// MARK: - Privates
extension OnboardingViewController {
    
    private func setupCollectionView() {
        collectionView.register(cellType: OnboardingViewCell.self)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        updateViews()
    }
    
    private func updateViews() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = collectionView.frame.size
            layout.minimumInteritemSpacing = 0.0
            layout.minimumLineSpacing = 0.0
        }
        doneButton.roundCorners(3)
    }
    
    private func setupBottomViews() {
        bottomContainerview.backgroundColor = .clear
    }
    
    private func setupPageControl() {
        /// pageControl
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.2)
        
        let itemSize: CGSize = .init(width: 10.0, height: 10.0)
        pageControl.currentPageIndicatorTintColor = ._green1
        pageControl.itemSize = itemSize
    }
}

extension OnboardingViewController {
    
}
