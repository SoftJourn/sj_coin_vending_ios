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
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        NavigationManager.shared.visibleViewController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        launch()
    }
    
    deinit {
        
        print("InitialViewController deinited")
    }
    
    private func launch() {
        
        Defaults[.fistLaunch] = true
        
        if AuthorizationManager.accessTokenExist() {
            fetchAllData {
                NavigationManager.shared.presentTabBarController()
            }
        } else {
            NavigationManager.shared.presentLoginViewController()
        }
    }
    
    private func fetchAllData(executeTask: @escaping ()->()) {
        
        firstly {
            self.fetchProducts().asVoid()
        }.then {
            self.fetchAccount().asVoid()
        }.then {
            self.fetchFavorites().asVoid()
        }.then {
            executeTask()
        }
    }
}
