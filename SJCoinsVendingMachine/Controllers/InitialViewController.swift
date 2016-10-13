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

class InitialViewController: UITabBarController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        SVProgressHUD.show()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        launch()
    }
    
    deinit {
        
        print("InitialViewController deinited")
    }
    
//    fileprivate func fetchMachines() {
//        
//        firstly {
//            APIManager.fetchMachines()
//        }.then { object -> Void in
//            DataManager.shared.save(object)
//            //self.launch()
//        }.catch { error in
//            print(error)
//            //SVProgressHUD.dismiss()
//            //AlertManager().present(retryAlert: errorTitle.download, message: errorMessage.retryDownload, action: self.predefinedAction())
//        }
//        //self.launch()
//    }
    
    fileprivate func launch() {
        
        if AuthorizationManager.accessTokenExist() {
            NavigationManager.shared.presentMachinesViewController()
        } else {
            NavigationManager.shared.presentLoginViewController()
        }
    }
//
//    fileprivate func predefinedAction() -> UIAlertAction {
//        
//        //Creating actions for ActionSheet and handle closures.
//        let action = UIAlertAction(title: "Retry", style: .destructive) { [unowned self] action in
//            SVProgressHUD.show()
//            self.fetchMachines()
//        }
//        return action
//    }
}
