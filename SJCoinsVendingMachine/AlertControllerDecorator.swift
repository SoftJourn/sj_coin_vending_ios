//
//  AlertViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/5/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import Alamofire

extension UIAlertController {
    
    class func presentAlert(with title: String, message: String) -> UIAlertController {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return controller
    }
    
    class func presentConfirmation(with message: String, actions: [UIAlertAction]) -> UIAlertController {
        
        let controller = UIAlertController(title: "Confirmation", message: message, preferredStyle: .alert)
        for action in actions {
            controller.addAction(action)
        }
        return controller
    }
    
    class func presentFilterSheet(with title: String?, message: String?, actions: [UIAlertAction]) -> UIAlertController {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            controller.addAction(action)
        }
        return controller
    }
    
    class func presentInternetConnectionError() -> UIAlertController {
        
        let controller = UIAlertController(title: errorTitle.reachability, message: errorMessage.reachability, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return controller
    }
}
