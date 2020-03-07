//
//  Swift+delay.swift
//  BreatheTrainer
//
//  Created by IgorBizi@mail.ru on 7/29/16.
//  Copyright © 2016 BiziApps. All rights reserved.
//

import Foundation
 
func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}


 
public extension DispatchQueue {
    
//    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
//    public class func once(token: String, block:()->Void) {
//        objc_sync_enter(self); defer { objc_sync_exit(self) }
//
//        if _onceTracker.contains(token) {
//            return
//        }
//
//        _onceTracker.append(token)
//        block()
//    }
}
