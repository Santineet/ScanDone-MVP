//
//  SettingsViewController.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var eventHandler: SettingsModuleInterface!
    var push = false
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var presentedViewController1: UIViewController?
    weak var presentedSettingsButton: UIButton?

    lazy var horizontalMenuUserInterface: HorizontalMenuViewController = {
        let wireframe = HorizontalMenuWireframe()
        wireframe.presenter.delegate = self
        wireframe.userInterface.dataSource = [.empty, .empty, .close]
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
extension SettingsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeBackBarButtonTitle()

        view.backgroundColor = .white
        setAttributedTitle("Menu".localized.uppercased())

        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear

        addChild(horizontalMenuUserInterface, childView: horizontalMenuView, superview: horizontalMenuContainerView)
        horizontalMenuView.reload()
        horizontalMenuUserInterface.theme = .clear
        
        eventHandler.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeNavBarShadow()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let tableViewHeight = self.tableView.frame.height
        let contentHeight = self.tableView.contentSize.height
        let centeringInset = (tableViewHeight - contentHeight) / 2.0 - navigationController!.navigationBar.bounds.height
        let topInset = max(centeringInset, 0.0)
        self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
}

//MARK: UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsItemCell.reuseIdentifier, for: indexPath) as! SettingsItemCell
        let option = SettingOption.allCases[indexPath.section]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        cell.titleLabel.attributedText = .init(string: option.name, attributes: [ .paragraphStyle: paragraphStyle, .foregroundColor: option.color, .font: UIFont._RobotoRegular(14), .kern: 1.4 ])
        return cell
    }

}


//EVENTS
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = SettingOption.allCases[indexPath.section]
        switch option {
        case .privacy:
            eventHandler.didSelectPrivacy()
        case .terms:
            eventHandler.didSelectTerms()
        case .contacts:
            eventHandler.didSelectSupport()
        case .subscription:
            eventHandler.didSelectSubscription()
        case .clearCache:
            eventHandler.didSelectClearCache()
        default: break
        }
    }

    
}


//METHODS.
extension SettingsViewController {
    
    func updateSettingsButton(_ button: UIButton, view: UIView) {
        
    }
}


extension SettingsViewController: SettingsViewInterface {

    func showContent(_ show: Bool) {
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: {
            if show {
                weakSelf?.tableView.alpha = 1
                weakSelf?.tableView.isUserInteractionEnabled = true
            } else {
                weakSelf?.tableView.alpha = 0.2
                weakSelf?.tableView.isUserInteractionEnabled = false
            }
        }) 
    }
    
}


extension SettingsViewController: HorizontalMenuDelegate {
    func moduleHorizontalMenu_didSelect(_ item: HorizontalMenuItem) {
        switch item {
        case .close:
            eventHandler.didSelectClose()
        default: break
        }
    }
}

