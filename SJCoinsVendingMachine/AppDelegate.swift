//
//  AppDelegate.swift
//  SJCoinsVendingMachine
//
//  Created by Maksym Gorodivskyi on 7/29/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //customSVProgressHUD()
        verifyFirstLaunch()
        return true
    }
    
//    private func customSVProgressHUD() {
//        
//        SVProgressHUD.setDefaultMaskType(.clear)
//        SVProgressHUD.setDefaultStyle(.light)
//    }
    
    private func verifyFirstLaunch() {
        
        if DataManager.shared.fistLaunch {
            do {
                try AuthorizationManager.keychain.remove("token")
                try AuthorizationManager.keychain.remove("refresh")
            } catch let error {
                print("error: \(error)")
            }
        }
    }
}
