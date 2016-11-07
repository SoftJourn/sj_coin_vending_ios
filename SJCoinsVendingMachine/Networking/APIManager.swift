//
//  APIManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/6/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON
import PromiseKit

class APIManager: RequestManager {
    
    typealias dataHandler = (_ object: AnyObject?, _ errorDescription: String?) -> ()

    // MARK: Fetching
    class func fetchMachines() -> Promise<AnyObject> {
        
        let promise = Promise<AnyObject> { fulfill, reject in
        
            let url = "\(networking.baseURL)vending/v1/machines"

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
            print("fetchProducts")
            let url = "\(networking.baseURL)vending/v1/machines/\(machineID)/features"
        
            firstly {
                sendDefault(request: .get, urlString: url)
            }.then { data -> Void in
                let featureModel = FeaturesModel.init(json: JSON(data))
                fulfill(featureModel)
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
    
    class func fetchFavorites() -> Promise<AnyObject> {
        print("fetchFavorites")
        let promise = Promise<AnyObject> { fulfill, reject in

            let url = "\(networking.baseURL)vending/v1/favorites"
        
            firstly {
                sendDefault(request: .get, urlString: url)
            }.then { data -> Void in
                let data = JSON(data)
                var favorites = [Products]()
                for (_, subJson):(String, JSON) in data {
                    //Create model object.
                    let object = Products.init(json: subJson)
                    //Add it to array.
                    favorites.append(object)
                }
                fulfill(favorites as AnyObject)
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
    
    class func fetchAccount() -> Promise<AnyObject> {
        print("fetchAccount")
        let promise = Promise<AnyObject> { fulfill, reject in

            let url = "\(networking.baseURL)coins/api/v1/account"
        
            firstly {
                sendDefault(request: .get, urlString: url)
            }.then { data -> Void in
                let account = AccountModel.init(json: JSON(data))
                fulfill(account)
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
    
    class func fetchPurchaseHistory() -> Promise<AnyObject> {
        
        let promise = Promise<AnyObject> { fulfill, reject in
            
            let url = "\(networking.baseURL)vending/v1/machines/last"
            
            firstly {
                sendDefault(request: .get, urlString: url)
            }.then { data -> Void in
                let data = JSON(data)
                var purchases = [PurchaseHistoryModel]()
                for (_, subJson):(String, JSON) in data {
                    //Create model object.
                    let object = PurchaseHistoryModel.init(json: subJson)
                    //Add it to array.
                    purchases.append(object)
                }
                fulfill(purchases as AnyObject)
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
    
    typealias withImage = (_ image: UIImage) -> ()
    
    class func fetch(image urlString : String, complition: @escaping withImage) {
        
        customManager.request("\(networking.baseURL)vending/v1/\(urlString)")
            .validate()
            .responseImage { response in
                switch response.result {
                case .success(let image):
                    DataManager.imageCache.add(image, withIdentifier: urlString)
                    complition(image)
                case .failure(let error):
                    print(error)
                    complition(picture.placeholder)
                }
        }
    }
    
    class func buy(product identifier: Int, machineID: Int) -> Promise<AnyObject> {
        
        let promise = Promise<AnyObject> { fulfill, reject in

            let url = "\(networking.baseURL)vending/v1/machines/\(machineID)/products/\(identifier)"
            
            firstly {
                sendDefault(request: .post, urlString: url)
            }.then { data -> Void in
                let json = JSON(data)
                let amount = json["amount"].intValue
                fulfill(amount as AnyObject)
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
    
    class func favorite(_ method: Alamofire.HTTPMethod, identifier: Int) -> Promise<AnyObject> {
        
        let promise = Promise<AnyObject> { fulfill, reject in

            let url = "\(networking.baseURL)vending/v1/favorites/\(identifier)"
            
            firstly {
                sendDefault(request: method, urlString: url)
            }.then { data -> Void in
                let model = Products.init(json: JSON(data))
                fulfill(model as AnyObject)
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
}
