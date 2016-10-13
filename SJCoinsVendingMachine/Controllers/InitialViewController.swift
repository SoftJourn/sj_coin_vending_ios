//
//  InitialViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 10/11/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD

class InitialViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        NavigationManager.shared.visibleViewController = self
        SVProgressHUD.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        launch()
    }
    
    deinit {
        
        print("InitialViewController deinited")
    }
    
    fileprivate func launch() {
        
        if AuthorizationManager.accessTokenExist() {
            NavigationManager.shared.presentTabBarController()
        } else {
            NavigationManager.shared.presentLoginViewController()
        }
    }
}
