//
//  InitialViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 10/11/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit

class InitialViewController: BaseViewController {
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        NavigationManager.shared.visibleViewController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        launchingProcess()
    }
    
    deinit {
        
        print("InitialViewController deinited")
    }
    
    // MARK: Launching.
    func launchingProcess() {
        //Verify internet connection.
        let actions = AlertManager().alertActions(cancel: false) {
            self.launchingProcess() //FIXME: Verify
        }
        Reachability.connectedToNetwork() ? tokenVerification() : present(alert: .retryLaunch(actions))
    }
    
    func tokenVerification() {
        //Verify token and ascertain if its a first launch.
        if AuthorizationManager.accessTokenExist() {
            DataManager.shared.fistLaunch = false
            regularLaunching()
        } else {
            DataManager.shared.fistLaunch = true
            NavigationManager.shared.presentLoginViewController()
        }
    }
}
