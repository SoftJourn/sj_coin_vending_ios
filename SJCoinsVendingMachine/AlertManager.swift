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
}
