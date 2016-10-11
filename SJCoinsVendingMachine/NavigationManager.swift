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
    //var tabBarController: UITabBarController?
    var visibleViewController: UIViewController?

    func presentTabBarController() {
        
        let tabBarController = create(viewController: storyboard.tabBarControllerIdentifier) as? UITabBarController
        guard let controller = tabBarController else { return }
        present(viewControllerAsRoot: controller)
    }
    
//    func presentExistingTabBarController() {
//        
//        presentControllerAsRoot(tabBarController!)
//    }
    
    func presentLoginViewController() {
        
        let loginViewController = create(viewController: LoginViewController.identifier)
        present(viewControllerAsRoot: loginViewController)
    }
    
    func mainStoryboard() -> UIStoryboard {
        
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
//    class func presentAllProductsViewController(with items: [Products]?, mode: Filter) {
//        
//        guard let navController = tabBarController!.viewControllers![2] as? UINavigationController,
//            let viewController = navController.viewControllers[0] as? AllProductsViewController else { return }
//        viewController.filterItems = SortingManager().sortBy(name: items)
//        viewController.filterMode = mode
//        viewController.usedSeeAll = true
//        tabBarController!.selectedIndex = 2
//    }
    
    fileprivate func create(viewController identifier: String) -> UIViewController {
        
        return mainStoryboard().instantiateViewController(withIdentifier: identifier)
    }
    
    fileprivate func present(viewControllerAsRoot viewController: UIViewController) {
        
        UIApplication.shared.keyWindow?.rootViewController? = viewController
    }
}
