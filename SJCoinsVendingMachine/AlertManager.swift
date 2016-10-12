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
        
        let alertController = UIAlertController.presentAlert(with: title, message: message)
        NavigationManager.shared.visibleViewController?.present(alertController, animated: true) { }
    }
    
    func present(retryAlert title: String, message: String, action: UIAlertAction) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(action)
        NavigationManager.shared.visibleViewController?.present(alertController, animated: true) { }
    }
    
    
    func present(actionSheet actions: [UIAlertAction]) {
        
        let actionSheet = UIAlertController.presentFilterSheet(with: nil, message: nil, actions: actions)
        NavigationManager.shared.visibleViewController?.present(actionSheet, animated: true) { }
    }
}
