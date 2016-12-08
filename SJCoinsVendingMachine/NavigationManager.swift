//
//  NavigationManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/2/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class NavigationManager: NSObject {
    
    // MARK: Constants
    let informativeControllerIdentifier = "InformativePageViewController"
    let tabBarControllerIdentifier = "TabBarController"
    let settingsControllerIdentifier = "SettingsNavigationController"
    let allItemsControllerIdentifier = "AllItemsViewController"
    let QRGeneratorControllerIdentifier = "QRCodeGeneratorViewController"
    let favoritesControllerIdentifier = "FavoritesViewController"

    let vc1Identifier = "VC1"
    let vc2Identifier = "VC2"
    
    // MARK: Properties
    static let shared = NavigationManager()
    var visibleViewController: UIViewController?
    var pageViewControllers: [UIViewController] {
        return [instantiate(with: vc1Identifier), instantiate(with: vc2Identifier), instantiate(with: LoginViewController.identifier)]
    }
    private var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    // MARK: Methods
    func presentInformativePageViewController(firstTime: Bool) {
    
        let informative = instantiate(with: informativeControllerIdentifier) as! InformativePageViewController
        informative.firstTime = firstTime
        present(viewControllerAsRoot: informative)
    }
    
    func presentTabBarController() {
        
        present(viewControllerAsRoot: instantiate(with: tabBarControllerIdentifier) as! UITabBarController)
    }
    
    func presentSettingsViewController() {
        
        let settingsController = instantiate(with: settingsControllerIdentifier) as! UINavigationController
        let controller = settingsController.viewControllers[0] as! SettingsViewController
        controller.delegate = visibleViewController as? HomeViewController
        visibleViewController?.present(settingsController, animated: true) { }
    }
    
    func presentQRGeneratorViewController() {
        
        let qrGeneratorController = instantiate(with: QRGeneratorControllerIdentifier) as! UINavigationController
        visibleViewController?.present(qrGeneratorController, animated: true) { }
    }
    
    func presentFavoritesViewController(items: [Products]?) {
        
        let favoritesViewController = instantiate(with: favoritesControllerIdentifier) as! FavoritesViewController
        visibleViewController?.navigationController?.pushViewController(favoritesViewController, animated: true)
    }

    func presentAllItemsViewController(name: String?, items: [Products]?) {
        
        let allItems = instantiate(with: allItemsControllerIdentifier) as! AllItemsViewController
        allItems.usedSeeAll = true
        allItems.titleButton(name)
        allItems.filterItems = SortingHelper().sortBy(name: items, state: nil)
        visibleViewController?.navigationController?.pushViewController(allItems, animated: true)
    }
    
    private func instantiate(with identifier: String) -> UIViewController {
        
        return mainStoryboard.instantiateViewController(withIdentifier: identifier)
    }
    
    private func present(viewControllerAsRoot: UIViewController) {
        
        UIApplication.shared.keyWindow?.rootViewController? = viewControllerAsRoot
    }
}
