//
//  AlertManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 10/11/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class AlertManager {
    
    func present(alert message: String) {
        
        let controller = UIAlertController(title: "", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        NavigationManager.shared.visibleViewController?.present(controller, animated: true) { }
    }
    
    func present(retryAlert message: String, actions: [UIAlertAction]) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        NavigationManager.shared.visibleViewController?.present(alertController, animated: true) { }
    }
    
    func present(actionSheet actions: [UIAlertAction], sender: UIButton) {
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for action in actions {
            controller.addAction(action)
        }
        if let popoverController = controller.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        NavigationManager.shared.visibleViewController?.present(controller, animated: true) { }
    }
    
    //Confirmation message.
    func present(confirmation name: String, price: Int, actions: [UIAlertAction]) {
        
        let controller = UIAlertController(title: "Confirm Purchase", message: "Buy \(name) for the \(price) coins?", preferredStyle: .alert)
        for action in actions {
            controller.addAction(action)
        }
        NavigationManager.shared.visibleViewController?.present(controller, animated: true) { }
    }
    
    //Retry download actions.
    func alertActions(cancel: Bool, retry: @escaping ()->()) -> [UIAlertAction] {
        
        let retryButton = UIAlertAction(title: buttonTitle.retry, style: .destructive) { _ in
            retry()
        }
        let cancelButton = UIAlertAction(title: buttonTitle.cancel, style: .default, handler: nil)
        return cancel ? [cancelButton, retryButton] : [retryButton]
    }

}
