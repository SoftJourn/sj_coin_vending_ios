//
//  BaseViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/28/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD

class BaseViewController: UIViewController {
    
    // MARK: Downloading, Handling and Refreshing data.
    func fetchProducts() {
        
        APIManager.fetchProducts { [unowned self] object, error in
            guard let object = object else { return self.present(.downloading(error)) }
            DataManager.shared.save(object)
            self.updateProducts()
        }
    }
    
    func updateProducts() {
        //Override in child.
    }
    
    func fetchFavorites() {
        
        APIManager.fetchFavorites { [unowned self] object, error in
            guard let object = object else { return self.present(.downloading(error)) }
            DataManager.shared.save(object)
            self.updateFavorites()
        }
    }
    
    func updateFavorites() {
        //Override in child.
    }
    
    func fetchAccount() {
        
        APIManager.fetchAccount { [unowned self] object, error in
            guard let object = object else { return self.present(.downloading(error)) }
            DataManager.shared.save(object)
            self.updateAccount()
        }
    }
    
    func updateAccount() {
        //Override in child.
    }
    
    enum errorType {
        
        case validation
        case authorization(Error)
        case downloading(Error?)
    }
    
    func present(_ error: errorType) {
        
        SVProgressHUD.dismiss()
        switch error {
        case .validation:
            AlertManager().present(alert: errorTitle.validation, message: errorMessage.validation)
        case .authorization(let error):
            AlertManager().present(alert: errorTitle.auth, message: error.localizedDescription)
        case .downloading(let error):
            guard let error = error else { return }
            AlertManager().present(alert: errorTitle.download, message: error.localizedDescription)
        }
    }
    
    
    
    //    // MARK: Confirmation and Buying.
    //    internal func presentConfirmation(with identifier: Int?, name: String?, price: Int?) {
    //        //FIXME: unwraping!
    //        let alertController =
    //            UIAlertController.presentConfirmation(with: "Buy \(name!) for the \(price!) coins?",
    //                actions: predefinedActions(with: identifier))
    //        present(alertController, animated: true) { }
    //    }
    //
    //    fileprivate func predefinedActions(with identifier: Int?) -> [UIAlertAction] {
    //
    //        let confirmButton = UIAlertAction(title: buttonTitle.confirm, style: .default) { action in
    //
    //            Reachability.ifConnectedToNetwork {
    //                self.executeBuying(by: identifier) { }
    //            }
    //        }
    //
    //        let cancelButton = UIAlertAction(title: buttonTitle.cancel, style: .default, handler: nil)
    //        return [confirmButton, cancelButton]
    //    }
    //
    //    fileprivate func executeBuying(by identifier: Int?, update: @escaping ()->()) {
    //
    //        guard let identifier = identifier else { return }
    //        SVProgressHUD.show()
    //        UploadManager.buyProduct(by: identifier) { [unowned self] object, error in
    //
    //            SVProgressHUD.dismiss()
    //            if error == nil {
    //                //Present success alert.
    //                self.presentBuyingResult(with: buying.successTitle, message: buying.successMessage)
    //                guard let object = object else { return }
    //                let amount = object as! Int
    //                //Save new balance in DataManager
    //                DataManager.singleton.saveAccount(balance: amount)
    //                //Use Closure for updating balance on interface (as example).
    //                update()
    //                /*
    //                 self.updateBalance(with: amount)
    //                 */
    //            } else {
    //                self.presentBuyingResult(with: buying.failedTitle, message: error!.localizedDescription)
    //            }
    //        }
    //    }
    //
    //    fileprivate func presentBuyingResult(with title: String, message: String) {
    //
    //        let alertController = UIAlertController.presentAlert(with: title, message: message)
    //        self.present(alertController, animated: true) { }
    //    }
}
