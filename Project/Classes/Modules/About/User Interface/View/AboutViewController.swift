//
//  AboutViewController.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class AboutViewController: UIViewController {
    
    var eventHandler: AboutModuleInterface!
    var push = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerLabel: UILabel!
    
}


//LIFECYCLE
extension AboutViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarShadow()

        setAttributedTitle("About".localized().uppercased())
                
        view.backgroundColor = ._light1
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 600
            
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.37
        paragraphStyle.alignment = .center
        footerLabel.attributedText = NSMutableAttributedString(string: "© 2019. All rights reserved".localized, attributes: [ NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.foregroundColor : UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.4), NSAttributedString.Key.font : UIFont._RobotoRegular(18)])
        
        eventHandler.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let tableViewHeight = self.tableView.frame.height
        let contentHeight = self.tableView.contentSize.height
        let centeringInset = (tableViewHeight - contentHeight) / 2.0 //- navigationController!.navigationBar.bounds.height
        let topInset = max(centeringInset, 0.0)
        print(topInset)
        self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.reuseIdentifier, for: indexPath) as! AboutCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    @objc override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch Density.value {
        case .group0, .group1: return 30
        case .group2: return 80
        case .group3: return 120
        case .group4: return 120
        case .group5: return 120
        default: return 80
        }
    }

}


//EVENTS
extension AboutViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
}


//METHODS
extension AboutViewController {
    
    
}


extension AboutViewController: AboutViewInterface {
    
    func reloadData() {
        if let view = tableView {
            view.reloadData()
        }
    }
    
}

