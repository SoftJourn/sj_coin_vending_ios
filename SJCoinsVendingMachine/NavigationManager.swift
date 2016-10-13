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
    var visibleViewController: UIViewController?
    
    func presentTabBarController() {
        
        let tabBarController = create(viewController: storyboards.tabBarControllerIdentifier) as! UITabBarController
        present(viewControllerAsRoot: tabBarController)
    }
    
    func presentMachinesViewController() {
        
        let navigationController = create(viewController: storyboards.navigationController) as! UINavigationController
        //navigationController.popToViewController(navigationController.viewControllers[1], animated: true)
        visibleViewController?.present(navigationController, animated: true) { }
    }
    
    func presentLoginViewController() {
        
        let navigationController = create(viewController: storyboards.navigationController) as! UINavigationController
        present(viewControllerAsRoot: navigationController)
    }
    
    fileprivate func create(viewController identifier: String) -> UIViewController {
        
        return mainStoryboard.instantiateViewController(withIdentifier: identifier)
    }
    
    fileprivate func present(viewControllerAsRoot: UIViewController) {
        
        UIApplication.shared.keyWindow?.rootViewController?.present(viewControllerAsRoot, animated: true) { }
    }
}
