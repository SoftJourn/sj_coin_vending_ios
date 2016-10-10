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
        
        tabBarController = createViewController(with: Storyboard.tabBarControllerIdentifier) as? UITabBarController
        presentControllerAsRoot(tabBarController!)
    }
    
    func presentExistingTabBarController() {
        
        presentControllerAsRoot(tabBarController!)
    }
    
    func presentLoginViewController() {
        
        presentControllerAsRoot(createViewController(with: LoginViewController.identifier))
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
    
    fileprivate class func createViewController(with identifier: String) -> UIViewController {
        return mainStoryboard.instantiateViewController(withIdentifier: identifier)
    }
    
    fileprivate class func presentControllerAsRoot(_ viewController: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController? = viewController
    }
}
