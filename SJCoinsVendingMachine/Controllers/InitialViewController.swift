//
//  InitialViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 10/11/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyUserDefaults

class InitialViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        NavigationManager.shared.visibleViewController = self
        SVProgressHUD.show(withStatus: spinerMessage.loading)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        launch()
    }
    
    deinit {
        
        print("InitialViewController deinited")
    }
    
    fileprivate func launch() {
        
        Defaults[.fistLaunch] = true
        
        if AuthorizationManager.accessTokenExist() {
            NavigationManager.shared.presentTabBarController()
        } else {
            NavigationManager.shared.presentLoginViewController()
        }
    }
}
