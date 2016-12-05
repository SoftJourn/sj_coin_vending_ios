//
//  NavigationManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/2/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class NavigationManager: NSObject {
    
    // MARK: Properties
    static let shared = NavigationManager()
    var visibleViewController: UIViewController?
    private var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    // MARK: Methods
    func presentTabBarController() {
        
        let tabBarController = create(viewController: storyboards.tabBarControllerIdentifier) as! UITabBarController
        present(viewControllerAsRoot: tabBarController)
    }
    
    func presentSettingsViewController() {
        
        let settingsController = create(viewController: storyboards.settingsNavigationController) as! UINavigationController
        let controller = settingsController.viewControllers[0] as! SettingsViewController
        controller.delegate = visibleViewController as! HomeViewController
        visibleViewController?.present(settingsController, animated: true) { }
    }
    
    func presentLoginViewController() {
        
        let loginController = create(viewController: LoginViewController.identifier)
        present(viewControllerAsRoot: loginController)
    }
    
    func presentFavoritesViewController(items: [Products]?) {
        
        let favoritesViewController = create(viewController: storyboards.favoritesViewController) as! FavoritesViewController
        visibleViewController?.navigationController?.pushViewController(favoritesViewController, animated: true)
    }

    func presentAllItemsViewController(name: String?, items: [Products]?) {
        
        let allItemsViewController = create(viewController: storyboards.allItemsViewController) as! AllItemsViewController
        allItemsViewController.usedSeeAll = true
        allItemsViewController.titleButton(name)
        allItemsViewController.filterItems = SortingHelper().sortBy(name: items, state: nil)
        visibleViewController?.navigationController?.pushViewController(allItemsViewController, animated: true)
    }
    
    private func create(viewController identifier: String) -> UIViewController {
        
        return mainStoryboard.instantiateViewController(withIdentifier: identifier)
    }
    
    private func present(viewControllerAsRoot: UIViewController) {
        
        UIApplication.shared.keyWindow?.rootViewController? = viewControllerAsRoot
    }
}
