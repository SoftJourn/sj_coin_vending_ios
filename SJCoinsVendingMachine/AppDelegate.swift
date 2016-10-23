//
//  AppDelegate.swift
//  SJCoinsVendingMachine
//
//  Created by Maksym Gorodivskyi on 7/29/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        customSVProgressHUD()
        return true
    }
    
    fileprivate func customSVProgressHUD() {
        
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.light)
    }
}

