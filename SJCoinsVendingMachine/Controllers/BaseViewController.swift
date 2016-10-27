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
    
    // MARK: Constants
    struct buying {
        struct title {
            static let success = "Success"
            static let failed = "Failed"
        }
        struct message {
            static let success = "Please take your order from Vending Machine."
            static let failed = "Vending Machine doesn't have full information about chosen product. Please reload data and try again."
        }
    }
    
    // MARK: Properies
    lazy var refreshControl: UIRefreshControl = {
        
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Refreshing")
        refresh.addTarget(self, action: #selector(fetchData), for: UIControlEvents.valueChanged)
        return refresh
    }()

    // MARK: Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    // MARK: Downloading, Handling and Refreshing data.
    func fetchData() {
        //SVProgressHUD.show(withStatus: spinerMessage.loading)
        if Reachability.connectedToNetwork() {
            self.refreshControl.endRefreshing()
            fetchContent()
        } else {
            //SVProgressHUD.dismiss(withDelay: 0.5)
            self.refreshControl.endRefreshing()
            present(alert: .connection)
        }
    }
    
    func fetchContent() {
        //Override in child.
    }
    
    // MARK: Fetch and update Products.
    func fetchProducts() -> Promise<AnyObject> {
        
        return Promise<AnyObject> { fulfill, reject in
            firstly {
                APIManager.fetchProducts(machineID: AuthorizationManager.getMachineId())
            }.then { object -> Void in
                print("fetchProducts result")
                DataManager.shared.save(object)
                fulfill(object)
            }.catch { error in
                self.present(alert: .downloading(error))
            }
        }
    }
    
    func fetchFavorites() -> Promise<AnyObject> {
    
        return Promise<AnyObject> { fulfill, reject in
            firstly {
                APIManager.fetchFavorites()
            }.then { object -> Void in
                print("fetchFavorites result")
                DataManager.shared.save(object)
                fulfill(object)
            }.catch { error in
                self.present(alert: .downloading(error))
            }
        }
    }
    
    func fetchAccount() -> Promise<AnyObject> {
        
        return Promise<AnyObject> { fulfill, reject in
            firstly {
                APIManager.fetchAccount()
            }.then { object -> Void in
                print("fetchAccount result")
                DataManager.shared.save(object)
                fulfill(object)
            }.catch { error in
                self.present(alert: .downloading(error))
            }
        }
    }
    
    func fetchPurchaseHistory() -> Promise<AnyObject> {
        
        return Promise<AnyObject> { fulfill, reject in

            firstly {
                APIManager.fetchPurchaseHistory()
            }.then { object -> Void in
                DataManager.shared.save(object)
                fulfill(object)
            }.catch { error in
                self.present(alert: .downloading(error))
            }
        }
    }
    
    // MARK: Confirmation and Buying.
    func present(confirmation product: Products) {
        
        guard let identifier = product.internalIdentifier, let name = product.name, let price = product.price else {
            return present(alert: .beforeBuying)
        }
        present(alert: .confirmation(name, price, buyingActions(with: identifier)))
    }
    
    fileprivate func buyingActions(with identifier: Int?) -> [UIAlertAction] {
        
        let confirmButton = UIAlertAction(title: buttonTitle.confirm, style: .default) { [unowned self] action in
            
            if Reachability.connectedToNetwork() {
                self.buy(using: identifier)
            } else {
                self.present(alert: .connection)
            }
        }
        let cancelButton = UIAlertAction(title: buttonTitle.cancel, style: .default, handler: nil)
        return [confirmButton, cancelButton]
    }
    
    func buy(using identifier: Int?) {
        
        guard let identifier = identifier else { return }
        SVProgressHUD.show(withStatus: spinerMessage.loading)
        APIManager.buy(product: identifier, machineID: AuthorizationManager.getMachineId()) { [unowned self] object, error in
            
            SVProgressHUD.dismiss(withDelay: 0.5)
            if object != nil {
                guard let amount = object else { return }
                DataManager.shared.save(balance: amount as! Int)
                self.present(alert: .buyingSuccess)
                self.updateUIafterBuying()
            } else {
                self.present(alert: .buying(error))
            }
        }
    }
    
    func updateUIafterBuying() {
        //Override in child.
    }
    
    // MARK: Add/Delete favorites.
    func add(favorite product: Products, complition: @escaping ()->()) {
        
        guard let identifier = product.internalIdentifier else { return }
        APIManager.favorite(.post, identifier: identifier) { [unowned self] object, error in
            if object != nil {
                SVProgressHUD.dismiss(withDelay: 0.2)
                DataManager.shared.add(favorite: object as! Products)
                complition()
            } else {
                self.present(alert: .favorite(error))
            }
        }
    }
    
    func remove(favorite product: Products, complition: @escaping ()->()) {
        
        guard let identifier = product.internalIdentifier else { return }
        APIManager.favorite(.delete, identifier: identifier) { [unowned self] object, error in
            if object != nil {
                SVProgressHUD.dismiss(withDelay: 0.2)
                DataManager.shared.remove(favorite: object as! Products)
                complition()
            } else {
                self.present(alert: .favorite(error))
            }
        }
    }
    
    // MARK: Alerts.
    enum alertType {
        
        case validation
        case authorization
        case downloading(Error?)
        case buying(Error?)
        case beforeBuying
        case connection
        case favorite(Error?)
        case buyingSuccess
        case confirmation(String, Int, [UIAlertAction])
    }
    
    func present(alert type: alertType) {
        
        SVProgressHUD.dismiss(withDelay: 0.5)
        switch type {
        case .validation:
            AlertManager().present(alert: myError.title.validation, message: myError.message.validation)
        case .authorization:
            AlertManager().present(alert: myError.title.auth, message: myError.message.auth)
        case .downloading(let error):
            AlertManager().present(alert: myError.title.download, message: error!.localizedDescription)
        case .buying(let error):
            AlertManager().present(alert: buying.title.failed, message: error!.localizedDescription)
        case .beforeBuying:
            AlertManager().present(alert: buying.title.failed, message: buying.message.failed)
        case .connection:
            AlertManager().present(alert: myError.title.reachability, message: myError.message.reachability)
        case .buyingSuccess:
            AlertManager().present(alert: buying.title.success, message: buying.message.success)
        case .favorite(let error):
            AlertManager().present(alert: myError.title.favorite, message: error!.localizedDescription)
        case .confirmation(let name, let price, let actions):
            AlertManager().present(confirmation: name, price: price, actions: actions)
        }
    }
}
