//
//  AlertManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 10/11/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class AlertManager {
    
    func present(alert title: String, message: String) {
        //FIXME:
        let controller = information(alert: title, message: message)
        NavigationManager.shared.visibleViewController?.present(controller, animated: true) { }
    }
    
    func present(retryAlert title: String, message: String, actions: [UIAlertAction]) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        NavigationManager.shared.visibleViewController?.present(alertController, animated: true) { }
    }
    
    func present(actionSheet actions: [UIAlertAction]) {
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for action in actions {
            controller.addAction(action)
        }
        NavigationManager.shared.visibleViewController?.present(controller, animated: true) { }
    }
    
    func presentInternetConnectionError() {
        
        let controller = information(alert: errorTitle.reachability, message: errorMessage.reachability)
        NavigationManager.shared.visibleViewController?.present(controller, animated: true) { }
    }
    
    //Confirmation message
    func present(confirmation name: String, price: Int, actions: [UIAlertAction]) {
        
        let controller = UIAlertController(title: "Confirmation", message: "Buy \(name) for the \(price) coins?", preferredStyle: .alert)
        for action in actions {
            controller.addAction(action)
        }
        NavigationManager.shared.visibleViewController?.present(controller, animated: true) { }
    }
    
    //Buying result message
    func buying(result title: String, message: String) {
        
        let controller = information(alert: title, message: message)
        NavigationManager.shared.visibleViewController?.present(controller, animated: true) { }
    }
    
    //Default alertController
    fileprivate func information(alert title: String, message: String) -> UIAlertController {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return controller
    }
}
