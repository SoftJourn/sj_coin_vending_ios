//
//  NavigationManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/2/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class NavigationManager: NSObject {
    
    static let shared = NavigationManager()
    var mainStoryboard: UIStoryboard {
        
        return UIStoryboard(name: "Main", bundle: nil)
    }
    //var tabBarController: UITabBarController?
    var visibleViewController: UIViewController?
    
    func presentTabBarController() {
        
        let tabBarController = create(viewController: storyboard.tabBarControllerIdentifier) as! UITabBarController
        present(viewControllerAsRoot: tabBarController)
    }
    
    func presentMachinesViewController() {
        
        let machinesViewController = create(viewController: MachinesViewController.identifier)
        present(viewControllerAsRoot: machinesViewController)
    }
    
    func presentLoginViewController() {
        
        let loginViewController = create(viewController: LoginViewController.identifier)
        present(viewControllerAsRoot: loginViewController)
    }
    
    fileprivate func create(viewController identifier: String) -> UIViewController {
        
        return mainStoryboard.instantiateViewController(withIdentifier: identifier)
    }
    
    fileprivate func present(viewControllerAsRoot: UIViewController) {
        
        UIApplication.shared.keyWindow?.rootViewController? = viewControllerAsRoot
    }
}
