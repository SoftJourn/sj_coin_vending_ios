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
    private struct buying {
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
        //refresh.attributedTitle = NSAttributedString(string: "Refreshing")
        refresh.addTarget(self, action: #selector(fetchData), for: UIControlEvents.valueChanged)
        return refresh
    }()
    let dataManager = DataManager.shared

    // MARK: Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    func connectionVerification(execute: ()->()) {
        
        if Reachability.connectedToNetwork() {
            execute()
        } else {
            refreshControl.endRefreshing()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [unowned self] in
                self.present(alert: .connection)
            }
        }
    }
    
    // MARK: Downloading, Handling and Refreshing data.
    func fetchData() {
        connectionVerification {
            fetchContent()
            refreshControl.endRefreshing()
        }
    }
    
    func fetchContent() {
        //Override in child.
    }
    
    // MARK: Fetch and update Products.
    func fetchProducts() -> Promise<AnyObject> {
        
        return Promise<AnyObject> { fulfill, reject in
            firstly {
                APIManager.fetchProducts(machineID: DataManager.shared.machineId)
            }.then { object -> Void in
                print("FetchProducts result comes from server")
                DataManager.shared.save(object)
                fulfill(object)
            }.catch { error in
                reject(error)
            }
        }
    }
    
    func fetchFavorites() -> Promise<AnyObject> {
    
        return Promise<AnyObject> { fulfill, reject in
            firstly {
                APIManager.fetchFavorites()
            }.then { object -> Void in
                print("FetchFavorites result comes from server")
                DataManager.shared.save(object)
                fulfill(object)
            }.catch { error in
                reject(error)
            }
        }
    }
    
    func fetchAccount() -> Promise<AnyObject> {
        
        return Promise<AnyObject> { fulfill, reject in
            firstly {
                APIManager.fetchAccount()
            }.then { object -> Void in
                print("FetchAccount result comes from server")
                DataManager.shared.save(object)
                fulfill(object)
            }.catch { error in
                reject(error)
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
                reject(error)
            }
        }
    }
    
    func fetchDefaultMachine() -> Promise<AnyObject> {
        
        return Promise<AnyObject> { fulfill, reject in
            firstly {
                APIManager.fetchMachines()
            }.then { object -> Void in
                let machines = object as! [MachinesModel]
                guard let identifier = machines[0].internalIdentifier, let name = machines[0].name else { return }
                DataManager.shared.machineId = identifier
                DataManager.shared.machineName = name
                fulfill(object)
            }.catch { error in
                reject(error)
            }
        }
    }

    func fetchMachinesList() -> Promise<AnyObject> {
        
        return Promise<AnyObject> { fulfill, reject in
            firstly {
                APIManager.fetchMachines()
            }.then { object -> Void in
                DataManager.shared.save(object)
                fulfill(object)
            }.catch { error in
                reject(error)
            }
        }
    }
    
    // MARK: Launching.
    func regularLaunching() {
                
        let favorites = fetchFavorites()
        let products = fetchProducts()
        let account = fetchAccount()
        
        when(fulfilled: favorites, products, account).then { _ in
            NavigationManager.shared.presentTabBarController()
        }.catch { _ in
            let actions = AlertManager().alertActions(cancel: false) { [unowned self] _ in
                self.regularLaunching()
            }
            self.present(alert: .retryLaunch(actions))
        }
    }
    
    // MARK: Confirmation and Buying.
    func present(confirmation product: Products) {
        
        guard let identifier = product.internalIdentifier, let name = product.name, let price = product.price else {
            return present(alert: .beforeBuying)
        }
        present(alert: .confirmation(name, price, buyingActions(with: identifier)))
    }
    
    private func buyingActions(with identifier: Int?) -> [UIAlertAction] {
        
        let confirmButton = UIAlertAction(title: buttonTitle.confirm, style: .destructive) { [unowned self] action in
            
            self.connectionVerification { [unowned self] in
                self.buy(using: identifier)
            }
        }
        let cancelButton = UIAlertAction(title: buttonTitle.cancel, style: .default, handler: nil)
        return [cancelButton, confirmButton]
    }
    
    private func buy(using identifier: Int?) {
        
        guard let identifier = identifier else { return }
        SVProgressHUD.show(withStatus: spinerMessage.loading)
        firstly {
            APIManager.buy(product: identifier, machineID: DataManager.shared.machineId)
        }.then { amount -> Void in
            SVProgressHUD.dismiss()
            DataManager.shared.save(balance: amount as! Int)
            self.present(alert: .buyingSuccess)
            self.updateUIafterBuying()
        }.catch { error in
            SVProgressHUD.dismiss()
            switch error {
            case serverError.notEnoughCoins(let errorDescription):
                self.present(alert: .buyingFailed(errorDescription))
            default:
                self.present(alert: .buyingFailed(String(error.localizedDescription)))
            }
        }
    }

    func updateUIafterBuying() {
        //Override in child.
    }
    
    // MARK: Add/Delete favorites.
    func add(favorite product: Products, complition: @escaping ()->()) {
        
        guard let identifier = product.internalIdentifier else { return }
        firstly {
            APIManager.favorite(.post, identifier: identifier)
        }.then { object -> Void in
            SVProgressHUD.dismiss(withDelay: 0.2)
            DataManager.shared.add(favorite: object as! Products)
            complition()
        }.catch { _ in
            self.present(alert: .favorite)
        }
    }
    
    func remove(favorite product: Products, complition: @escaping ()->()) {
        
        guard let identifier = product.internalIdentifier else { return }
        firstly {
            APIManager.favorite(.delete, identifier: identifier)
        }.then { object -> Void in
            SVProgressHUD.dismiss(withDelay: 0.2)
            DataManager.shared.remove(favorite: object as! Products)
            complition()
        }.catch { _ in
            self.present(alert: .favorite)
        }
    }
    
    // MARK: Alerts.
    enum alertType {
        
        case validation
        case authorization
        case downloading
        case beforeBuying
        case connection
        case buyingSuccess
        case buyingFailed(String)
        case favorite
        case confirmation(String, Int, [UIAlertAction])
        case retryLaunch([UIAlertAction])
    }
    
    func present(alert type: alertType) {
        
        SVProgressHUD.dismiss(withDelay: 0.5)
        switch type {
            
        case .validation:
            AlertManager().present(alert: myError.title.validation, message: myError.message.validation)
        
        case .authorization:
            AlertManager().present(alert: myError.title.auth, message: myError.message.auth)
        
        case .downloading:
            AlertManager().present(alert: myError.title.download, message: myError.message.download)
        
        case .beforeBuying:
            AlertManager().present(alert: buying.title.failed, message: buying.message.failed)
        
        case .connection:
            AlertManager().present(alert: myError.title.reachability, message: myError.message.reachability)
        
        case .buyingSuccess:
            AlertManager().present(alert: buying.title.success, message: buying.message.success)
        
        case .buyingFailed(let errorDescription):
            AlertManager().present(alert: buying.title.failed, message: errorDescription)
        
        case .favorite:
            AlertManager().present(alert: myError.title.favorite, message: myError.message.favorite)
        
        case .confirmation(let name, let price, let actions):
            AlertManager().present(confirmation: name, price: price, actions: actions)
        
        case .retryLaunch(let actions):
            AlertManager().present(retryAlert: myError.title.download, message: myError.message.download, actions: actions)
        }
    }
}

