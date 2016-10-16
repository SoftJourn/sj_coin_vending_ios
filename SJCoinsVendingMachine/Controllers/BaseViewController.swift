//
//  BaseViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/28/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit

class BaseViewController: UIViewController {
    
    let placeholder = UIImage(named: "Placeholder")!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchContent), name: .machineChanged, object: nil)
    }
    
    // MARK: Constants
    lazy var refreshControl: UIRefreshControl = {
        
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Refreshing")
        refresh.addTarget(self, action: #selector(fetchContent), for: UIControlEvents.valueChanged)
        return refresh
    }()
    
    func fetchContent() {
        
    }
    
    // MARK: Downloading, Handling and Refreshing data.
    func fetchProducts() {
        
        firstly {
            APIManager.fetchProducts(machineID: AuthorizationManager.getMachineId())
        }.then { object -> Void in
            DataManager.shared.save(object)
            self.updateProducts()
        }.catch { error in
            self.present(.downloading(error))
        }
    }
    
    func updateProducts() {
        //Override in child.
    }
    
    func fetchFavorites() {
        
        firstly {
            APIManager.fetchFavorites()
        }.then { object -> Void in
            DataManager.shared.save(object)
            self.updateFavorites()
        }.catch { error in
            self.present(.downloading(error))
        }
    }
    
    func updateFavorites() {
        //Override in child.
    }
    
    func fetchAccount() {
        
        firstly {
            APIManager.fetchAccount()
        }.then { object -> Void in
            DataManager.shared.save(object)
            self.updateAccount()
        }.catch { error in
            self.present(.downloading(error))
        }
    }

    func updateAccount() {
        //Override in child.
    }
    
    enum errorType {
        
        case validation
        case authorization
        case downloading(Error?)
    }
    
    func present(_ error: errorType) {
        
        SVProgressHUD.dismiss()
        switch error {
        case .validation:
            AlertManager().present(alert: errorTitle.validation, message: errorMessage.validation)
        case .authorization:
            AlertManager().present(alert: errorTitle.auth, message: errorMessage.auth)
        case .downloading(let error):
            guard let error = error else { return }
            AlertManager().present(alert: errorTitle.download, message: error.localizedDescription)
        }
    }
    
    // MARK: Confirmation and Buying.
    func confirmation(_ identifier: Int?, name: String?, price: Int?, actions: [UIAlertAction]) {
        
        guard let identifier = identifier, let name = name, let price = price else { return }
        AlertManager().present(confirmation: name, price: price, actions: buyingActions(with: identifier))
    }
    
    fileprivate func buyingActions(with identifier: Int?) -> [UIAlertAction] {
        
        let confirmButton = UIAlertAction(title: buttonTitle.confirm, style: .default) { action in
            Reachability.ifConnectedToNetwork {
                self.execute(buying: identifier) { }
            }
        }
        let cancelButton = UIAlertAction(title: buttonTitle.cancel, style: .default, handler: nil)
        return [confirmButton, cancelButton]
    }
    
    func execute(buying identifier: Int?, update: @escaping ()->()) {
        
        guard let identifier = identifier else { return }
        SVProgressHUD.show()
        APIManager.buy(product: identifier, machineID: AuthorizationManager.getMachineId()) { [unowned self] object, error in
            
            SVProgressHUD.dismiss()
            if error == nil {
                //Present success alert.
                self.presentBuyingResult(with: buying.successTitle, message: buying.successMessage)
                guard let object = object else { return }
                let amount = object as! Int
                //Save new balance in DataManager
                DataManager.shared.saveAccount(balance: amount)
                //Use Closure for updating balance on interface (as example).
                update()
            } else {
                self.presentBuyingResult(with: buying.failedTitle, message: error!.localizedDescription)
            }
        }
    }
    
    func presentBuyingResult(with title: String, message: String) {
        
        let alertController = UIAlertController.presentAlert(with: title, message: message)
        self.present(alertController, animated: true) { }
    }
}
