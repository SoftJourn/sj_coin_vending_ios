//
//  APIManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/6/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

class APIManager: RequestManager {
    
    // MARK: Constants
    static let pathMachines = "vending/v1/machines"
    static let pathFavorites = "vending/v1/favorites"

    // MARK: Fetching
    class func fetchMachines() -> Promise<AnyObject> {
        
        let promise = Promise<AnyObject> { fulfill, reject in
        
            let url = "\(networking.baseURL)\(pathMachines)"

            firstly {
                sendDefault(request: .get, urlString: url)
            }.then { data -> Void in
                let data = JSON(data)
                var machines = [MachinesModel]()
                for (_, subJson):(String, JSON) in data {
                    machines.append(MachinesModel(json: subJson))
                }
                fulfill(machines as AnyObject)
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
    
    class func fetchProducts(machineID: Int)  -> Promise<AnyObject> {
        
        let promise = Promise<AnyObject> { fulfill, reject in
            
            let url = "\(networking.baseURL)\(pathMachines)/\(machineID)/features"
        
            firstly {
                sendDefault(request: .get, urlString: url)
            }.then { data -> Void in
                fulfill(FeaturesModel(using: data))
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
    
    class func fetchFavorites() -> Promise<AnyObject> {

        let promise = Promise<AnyObject> { fulfill, reject in

            let url = "\(networking.baseURL)\(pathFavorites)"
        
            firstly {
                sendDefault(request: .get, urlString: url)
            }.then { data -> Void in
                let data = JSON(data)
                var favorites = [Products]()
                for (_, subJson):(String, JSON) in data {
                    //Add to array created model object.
                    favorites.append(Products(json: subJson))
                }
                fulfill(favorites as AnyObject)
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
    
    class func fetchAccount() -> Promise<AnyObject> {

        let promise = Promise<AnyObject> { fulfill, reject in

            let url = "\(networking.baseURL)coins/api/v1/account"
        
            firstly {
                sendDefault(request: .get, urlString: url)
            }.then { data -> Void in
                fulfill(AccountModel(using: data))
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
    
    class func fetchPurchaseHistory() -> Promise<AnyObject> {
        
        let promise = Promise<AnyObject> { fulfill, reject in
            
            let url = "\(networking.baseURL)\(pathMachines)/last"
            
            firstly {
                sendDefault(request: .get, urlString: url)
            }.then { data -> Void in
                let data = JSON(data)
                var purchases = [PurchaseHistoryModel]()
                for (_, subJson):(String, JSON) in data {
                    //Add to array created model object.
                    purchases.append(PurchaseHistoryModel(json: subJson))
                }
                fulfill(purchases as AnyObject)
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
    
    class func buy(product identifier: Int, machineID: Int) -> Promise<AnyObject> {
        
        let promise = Promise<AnyObject> { fulfill, reject in

            let url = "\(networking.baseURL)\(pathMachines)/\(machineID)/products/\(identifier)"
            
            firstly {
                sendDefault(request: .post, urlString: url)
            }.then { data -> Void in
                fulfill(JSON(data)[key.amount].intValue as AnyObject)
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
    
    class func favorite(_ method: Alamofire.HTTPMethod, identifier: Int) -> Promise<AnyObject> {
        
        let promise = Promise<AnyObject> { fulfill, reject in

            let url = "\(networking.baseURL)\(pathFavorites)/\(identifier)"
            
            firstly {
                sendDefault(request: method, urlString: url)
            }.then { data -> Void in
                fulfill(Products(json: JSON(data)) as AnyObject)
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
}
