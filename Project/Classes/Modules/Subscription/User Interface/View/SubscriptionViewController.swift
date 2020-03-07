//
//  SubscriptionViewController.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class SubscriptionViewController: UIViewController {
    
    var eventHandler: SubscriptionModuleInterface!
    var push = true
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource = [SubscriptionItem]()
    var noContentView: NoContentView!
        
    lazy var restoreButtonItem: UIBarButtonItem = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(.init(string: "Restore".localized.uppercased(), attributes: [ .foregroundColor: UIColor._green3, .font: UIFont._RobotoRegular(12), .kern: 1.8 ]), for: .normal)
        button.tap(self, action: #selector(restoreButtonAction(_:)))
        return UIBarButtonItem(customView: button)
    }()
}


//LIFECYCLE
extension SubscriptionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch eventHandler.presentType {
        case .onboarding:
            navigationItem.hidesBackButton = true
        default:
            navigationItem.hidesBackButton = false
        }
        
        addNavBarShadow()
        navigationItem.rightBarButtonItem = restoreButtonItem

        setAttributedTitle("Subscription".localized().uppercased())
        noContentView = NoContentView.create(.offline, superview: view)
        
        view.backgroundColor = ._light1
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 600
        
        tableView.register(UINib(nibName: BuySubscriptionCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: BuySubscriptionCell.reuseIdentifier)
        
        weak var weakSelf = self
        tableView.addPullToRefresh {
            weakSelf?.eventHandler.didSelectRefresh()
        }
        
        eventHandler.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return dataSource.isEmpty ? 0 : 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionTitleCell.reuseIdentifier, for: indexPath) as! SubscriptionTitleCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: BuySubscriptionCell.reuseIdentifier, for: indexPath) as! BuySubscriptionCell
            let item = dataSource.filter({ $0.type == .Weekly }).first
            cell.subtitle = item?.priceAndCurrency
            cell.title = "PLAN A: 1 WEEK".localized()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: BuySubscriptionCell.reuseIdentifier, for: indexPath) as! BuySubscriptionCell
            let item = dataSource.filter({ $0.type == .Monthly }).first
            cell.subtitle = item?.priceAndCurrency
            cell.title = "PLAN B: 1 MONTH".localized()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: BuySubscriptionCell.reuseIdentifier, for: indexPath) as! BuySubscriptionCell
            let item = dataSource.filter({ $0.type == .Monthly3 }).first
            cell.subtitle = item?.priceAndCurrency
            cell.title = "PLAN C: 3 MONTHS".localized()
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionFooterCell.reuseIdentifier, for: indexPath) as! SubscriptionFooterCell
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionButtonsCell.reuseIdentifier, for: indexPath) as! SubscriptionButtonsCell
            cell.leftButton.addTarget(self, action: #selector(termsButtonAction(_:)), for: .touchUpInside)
            cell.rightButton.addTarget(self, action: #selector(privacyButtonAction(_:)), for: .touchUpInside)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.28
            let attributes : [NSAttributedString.Key: Any] = [
                .font : UIFont._RobotoMedium(14),
                .foregroundColor : UIColor._green3,
                .paragraphStyle : paragraphStyle ]
            cell.leftButton.setAttributedTitle(NSMutableAttributedString(string: "Terms of service".localized.uppercased(), attributes: attributes), for: .normal)
            cell.rightButton.setAttributedTitle(NSMutableAttributedString(string: "Privacy policy".localized.uppercased(), attributes: attributes), for: .normal)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            switch Density.value {
            case .group0, .group1: return 10
            case .group2: return 40
            case .group3: return 50
            case .group4: return 70
            case .group5: return 80
            default: return 30
            }
        case 1:
            switch Density.value {
            case .group0, .group1: return 10
            case .group2: return 30
            case .group3: return 40
            case .group4: return 70
            case .group5: return 80
            default: return 30
            }
        case 4:
            switch Density.value {
            case .group0, .group1: return 10
            case .group2: return 30
            case .group3: return 40
            case .group4: return 50
            case .group5: return 60
            default: return 30
            }
        default:
            return 0.001
        }
    }

//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == tableView.numberOfSections - 1 {
//            return 30*UIFont.delta
//        }
//        return 0.1
//    }

}


//EVENTS
extension SubscriptionViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 1:
            if let item = dataSource.filter({ $0.type == .Weekly }).first {
                eventHandler.didSelectItem(item)
            }
        case 2:
            if let item = dataSource.filter({ $0.type == .Monthly }).first {
                eventHandler.didSelectItem(item)
            }
        case 3:
            if let item = dataSource.filter({ $0.type == .Monthly3 }).first {
                eventHandler.didSelectItem(item)
            }
        default: break
        }
    }
    
    @objc func privacyButtonAction(_ sender: UIButton) {
        eventHandler.didSelectPrivacy()
    }
    
    @objc func termsButtonAction(_ sender: UIButton) {
        eventHandler.didSelectTerms()
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        eventHandler.didSelectClose()
    }
    
    @objc func restoreButtonAction(_ sender: Any) {
        eventHandler.didSelectRestore()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //constraint_bottomView_topToSafeArea.constant = min(-scrollView.contentOffset.y, -1)
    }
}


//METHODS.
extension SubscriptionViewController {
    
    
}


extension SubscriptionViewController: SubscriptionViewInterface {
    
    func reloadData() {
        if let view = tableView {
            view.reloadData()
        }
    }
    
    func showNoContent(_ flag: Bool) {
        noContentView.show(flag)
        //tableView.isHidden = flag
    }
    
    func showContent(_ show: Bool) {
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: {
            if show {
                weakSelf?.tableView.alpha = 1
                weakSelf?.tableView.isUserInteractionEnabled = true
            } else if weakSelf?.dataSource.isEmpty == false {
                weakSelf?.tableView.alpha = 0.2
                weakSelf?.tableView.isUserInteractionEnabled = false
            }
        }) 
    }
}

