//
//  InitialViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 10/11/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
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
    
    // MARK: Launching.
    func launchingProcess() {
        //Verify internet connection.
        let actions = AlertManager().alertActions(cancel: false) {
            self.launchingProcess()
        }
        Helper.connectedToNetwork() ? tokenVerification() : present(alert: .retryLaunchNoInternet(actions))
    }
    
    func tokenVerification() {
        //Verify token and ascertain if its a first launch.
        if !DataManager.shared.launchedBefore && !AuthorizationManager.accessTokenExist() {
            DataManager.shared.launchedBefore = true
            NavigationManager.shared.presentInformativePageViewController(firstTime: true)
        } else if DataManager.shared.launchedBefore && AuthorizationManager.accessTokenExist() { // ?????
            regularLaunching()
        } else {
            NavigationManager.shared.presentInformativePageViewController(firstTime: false)
        }
    }
}
