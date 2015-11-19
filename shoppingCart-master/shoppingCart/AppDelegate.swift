//
//  AppDelegate.swift
//  shoppingCart
//
//  Created by Solo on 15/11/17.
//  Copyright © 2015年 Solo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 手动创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // 设置window的根控制器
        window?.rootViewController = UINavigationController(rootViewController: JFGoodListViewController())
        
        // 设置window为主window并显示在窗口
        window?.makeKeyAndVisible()
        
        return true
    }




}

