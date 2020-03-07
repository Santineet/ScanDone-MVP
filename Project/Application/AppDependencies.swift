//
//  AppDependencies.swift
//  Chat
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit
import Firebase
import FontBlaster


class AppDependencies: NSObject {
    var splashWireframe: SplashWireframe?
    var folderListWireframe: FolderListWireframe!
    var inAppPurchaseDataManagerAPI = InAppPurchaseDataManagerAPI.shared
    var networkManagerRegister = NetworkManagerRegister()

    //MARK: LifeCycle
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate), name: UIApplication.willTerminateNotification, object: nil)

        configureDependencies()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
    }
    
    static var shared: AppDependencies {
        return (UIApplication.shared.delegate as! AppDelegate).appDependencies
    }
    
    static var appDelegate: AppDelegate {
        return (UIApplication.shared.delegate as! AppDelegate)
    }
    
    func configureDependencies() {
        registerDefaults()
 
        FontBlaster.blast() { (fonts) in
            //print(fonts)
        }
        
        AppTheme.applyTheme()
        MagicalRecord.setupCoreDataStack(withStoreNamed: "Model")
        MagicalRecord.setLoggingLevel(.off)
        
        FirebaseApp.configure()
        AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(App.enableAnalytics)

        inAppPurchaseDataManagerAPI.setup()

        
        if let isEmpty = FolderItem.mr_findAll()?.isEmpty, isEmpty == true, App.showTestDocuments == true {
            let image = UIImage.init(named: "document-temp")!
            FolderItem.create([ImportItem.init(image)]) { (_) in
                FolderItem.create([ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image)]) { (_) in
                    FolderItem.create([ImportItem.init(image), ImportItem.init(image)]) { (_) in
                        FolderItem.create([ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image)]) { (_) in
                            FolderItem.create([ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image)]) { (_) in
                                FolderItem.create([ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image)]) { (_) in
                                    FolderItem.create([ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image), ImportItem.init(image)]) { (_) in
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        //print("__")
        //print(Document.mr_findAll()?.count)
        //print(FileItem.mr_findAll()?.count)

        
    }
    
    
    func didSetRootWindow() {

    }
    
    func registerDefaults() {
        UserDefaults.standard.register(defaults: [
            "tets valie" : "test 1",
            ])
    }
    
    @objc func applicationDidBecomeActive() {

    }
    
    @objc func applicationWillEnterForeground() {
        
    }
    
    @objc func applicationWillResignActive() {
        
    }
    
    @objc func applicationDidEnterBackground() {
        
    }
    
    @objc func applicationWillTerminate() {
        MagicalRecord.cleanUp()
    }
    
    func setupRootWindow(_ window: UIWindow?) {
        if App.skipLaunchImage {
            folderListWireframe = FolderListWireframe(window: window)
        } else {
            splashWireframe = SplashWireframe(window: window)
        }
        didSetRootWindow()
    }
    
}



 
