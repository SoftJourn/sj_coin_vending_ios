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
import PromiseKit

class InitialViewController: BaseViewController {
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        NavigationManager.shared.visibleViewController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        connectionVerification {
            tokenVerification()
        }
    }
    
    deinit {
        
        print("InitialViewController deinited")
    }
    
    private func tokenVerification() {
        
        if AuthorizationManager.accessTokenExist() {
            launching(firstTime: false)
        } else {
            DataManager.shared.fistLaunch = true
            NavigationManager.shared.presentLoginViewController()
        }
    }
}
