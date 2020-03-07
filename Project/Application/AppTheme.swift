//
//  AppTheme.swift
//  Chat
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit
import DeviceKit

class AppTheme {
    static func applyTheme() {
        applyNavigationTheme()
//        
//        UIBarButtonItem.appearance().setb
//        //if SYSTEM_VERSION_LESS_THAN(version: "11") {
//        // UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for: .default) //hide back button
//        //        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.clear], forfor: .normal)
//        //        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.clear], for: .highlighted)
//        
       
        for i in [.normal, .selected, .highlighted] as [UIControl.State] {
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor._green3, .font: UIFont._RobotoRegular(12), .kern: 1.8 ] as [NSAttributedString.Key : Any]
            UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: i)
        }


        
        //        //
        UITabBar.appearance().barTintColor = ._green1
        UITabBar.appearance().tintColor = UIColor.white
//        //        UITabBar.appearance().isTranslucent = false
//        //        UITabBar.appearance().shadowImage = UIImage()
//        //        UITabBar.appearance().backgroundImage = UIImage()
//        
//        //        UISegmentedControl.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont._regular(13)], for: .normal)
//
        
        UIApplication.shared.statusBarStyle = .default
        UIApplication.statusBar(show: true)
//        //        UIApplication.statusBarBackgroundColor(.clear)
//        
        LoadingHud.color = UIColor._green1
//
        
    }

}

extension AppTheme {
    
    private static func applyNavigationTheme() {
        let bar = UINavigationBar.appearance()
        
        /// Translucent navigation bar
//        bar.setBackgroundImage(UIImage(), for: .default)
        bar.shadowImage = UIImage()
        bar.isTranslucent = false
        
        /// Colors
        bar.backgroundColor = .white
        bar.barTintColor = .white
        bar.tintColor = ._green1
        
        /// titleTextAttributes
        let titleAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 1),
            .font: UIFont._RobotoRegular(12)
        ]
        bar.titleTextAttributes = titleAttrs
        
        //        AppDependencies.appDelegate().window?.tintColor = UIView().tintColor!
        
        //        UINavigationBar.appearance().backgroundColor = UIColor.clear
        //        UINavigationBar.appearance().tintColor = UIColor.black
        //        //         UINavigationBar.appearance().barTintColor = UIColor.clear //status bar
        //        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont._medium(22), NSForegroundColorAttributeName: UIColor(red: 9/255.0, green: 27/255.0, blue: 64/255.0, alpha: 1)]
        //        UINavigationBar.appearance().setTitleVerticalPositionAdjustment(13, for: .default)
        //
        //        UINavigationBar.appearance().shadowImage = UIImage()
        //        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        //        //UINavigationBar.appearance().isTranslucent = false
        //
        //        //horizontal
        //        let leftPadding: CGFloat = 18
        //        let bottomPadding: CGFloat = 0
        //        let backImage = UIImage(named: "icMainBackNormal")!
        //        UIGraphicsBeginImageContextWithOptions(CGSize(width: backImage.size.width + leftPadding, height: backImage.size.height), false, 0)
        //        backImage.draw(at: CGPoint(x: leftPadding, y: 0))
        //        let backImageEditted = UIGraphicsGetImageFromCurrentImageContext()?.withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, -bottomPadding, 0))
        //        UIGraphicsEndImageContext()
        //        UINavigationBar.appearance().backIndicatorImage = backImageEditted
        //        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImageEditted
        //        //vertical
        //        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -11), for: .default)
        
        //horizontal
        var navBackImage = R.image.imageNavItemBack()!
        let leftPadding: CGFloat = 8.0
        let adjustSizeForBetterHorizontalAlignment = CGSize(
            width: navBackImage.size.width + leftPadding,
            height: navBackImage.size.height
        )
        
        UIGraphicsBeginImageContextWithOptions(adjustSizeForBetterHorizontalAlignment, false, 0)
        navBackImage.draw(at: CGPoint(x: leftPadding, y: 0.0))
        navBackImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let finalImage = navBackImage.withRenderingMode(.alwaysOriginal)
        bar.backIndicatorImage = finalImage
        bar.backIndicatorTransitionMaskImage = finalImage
    }
}
