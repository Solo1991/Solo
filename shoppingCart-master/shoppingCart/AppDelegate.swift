//
//  AppDelegate.swift
//  shoppingCart
//
//  Created by Solo on 15/11/17.
//  Copyright © 2015年 Solo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        
        self.setRootWindow();
        return true
    }
    
    
    /**
     *创建一个window
     */
    func setRootWindow()
    {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        window?.rootViewController = UINavigationController(rootViewController: JFGoodListVC())
        
        window?.makeKeyAndVisible()
    }
}

