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
    struct myError {
        struct title {
            static let validation = "Validation Error"
            static let auth = "Authorization Error"
            static let download = "Downloading Error"
            static let reachability = "Internet Error"
            static let favorite = "Favorite Error"
        }
        struct message {
            static let validation = "Login and password should not be empty."
            static let auth = "Login failed."
            static let reachability = "Please verify your Internet connection."
            static let retryDownload = "Error held while fetching list of machines. Please try again."
            static let favorite = "Error held while adding to favorite. Please try again."
        }
    }
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: .machineChanged, object: nil)
    }
    
    // MARK: Downloading, Handling and Refreshing data.
    func fetchData() {
        //SVProgressHUD.show(withStatus: spinerMessage.loading)
        if Reachability.connectedToNetwork() {
            fetchContent()
            self.refreshControl.endRefreshing()
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
    func fetchProducts() {
        
        firstly {
            APIManager.fetchProducts(machineID: AuthorizationManager.getMachineId())
        }.then { object -> Void in
            DataManager.shared.save(object)
            self.updateProducts()
        }.catch { error in
            self.present(alert: .downloading(error))
        }
    }
    
    func updateProducts() {
        //Override in child.
    }
    
    // MARK: Fetch and update Favorites.
    func fetchFavorites() {
        
        firstly {
            APIManager.fetchFavorites()
        }.then { object -> Void in
            DataManager.shared.save(object)
            self.updateFavorites()
        }.catch { error in
            self.present(alert: .downloading(error))
        }
    }
    
    func updateFavorites() {
        //Override in child.
    }
    
    // MARK: Fetch and update Account.
    func fetchAccount() {
        
        firstly {
            APIManager.fetchAccount()
        }.then { object -> Void in
            DataManager.shared.save(object)
            self.updateAccount()
        }.catch { error in
            self.present(alert: .downloading(error))
        }
    }
    
    func updateAccount() {
        //Override in child.
    }
    
    // MARK: Fetch and update Purchase history.
    func fetchPurchaseHistory() {
        
        firstly {
            APIManager.fetchPurchaseHistory()
        }.then { object -> Void in
            DataManager.shared.save(object)
            self.updatePurchaseHistory()
        }.catch { error in
            self.present(alert: .downloading(error))
        }
    }
    
    func updatePurchaseHistory() {
        //Override in child.
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
            if error == nil {
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
            //FIXME: Verify Response could not be serialized, input data was nil or zero length.

            //if error == nil {
                DataManager.shared.add(favorite: product)
                SVProgressHUD.dismiss(withDelay: 0.5)
                complition()
            //} else {
            //    self.present(alert: .favorite(error))
            //}
        }
    }
    
    func remove(favorite product: Products, complition: @escaping ()->()) {
        
        guard let identifier = product.internalIdentifier else { return }
        APIManager.favorite(.delete, identifier: identifier) { /*[unowned self]*/ object, error in
            //if error == nil {
                DataManager.shared.remove(favorite: product)
                complition()
//            } else {
//                self.present(alert: .favorite(error))
//            }
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
