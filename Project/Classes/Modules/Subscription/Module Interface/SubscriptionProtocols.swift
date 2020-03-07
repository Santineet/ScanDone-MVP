//
//  SubscriptionProtocols.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


protocol SubscriptionDataManagerAPIInput: class {
    
    func loadList(_ completion: @escaping (_ items: [SubscriptionItem], _ error: Error?) -> Void)
    func buy(_ item: SubscriptionItem, completion: @escaping (_ error: Error?) -> Void)
    func restore(_ completion: @escaping (_ error: Error?) -> Void)

}


protocol SubscriptionDataManagerLocalInput: class {
    
    
}


protocol SubscriptionInteractorInput: class {
    
    func loadList()
    func buy(_ item: SubscriptionItem)  
    func restore()
}


protocol SubscriptionInteractorOutput: class {
    
    func didLoadList(_ items: [SubscriptionItem], error: Error?)
    func didRestore(_ error: Error?)
    func didBuy(_ error: Error?)
}


protocol SubscriptionModuleInterface: class {
    var delegate: SubscriptionDelegate? { get set }
    var presentType: SubscriptionPresentType { get }
    
    func viewDidLoad()
    func didSelectClose()
    func didSelectItem(_ item: SubscriptionItem)
    func didSelectRestore()
    func didSelectPrivacy()
    func didSelectTerms()
    func didSelectRefresh()

}


protocol SubscriptionViewInterface: class {
    
    var dataSource: [SubscriptionItem] { get set }
    func reloadData()
}


protocol SubscriptionWireframeInput: class {
    
    
}


protocol SubscriptionDelegate: class {
    func moduleSubscription_didClose()
}

