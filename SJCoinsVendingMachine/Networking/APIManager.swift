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
    
    typealias dataHandler = (_ object: AnyObject?, _ error: Error?) -> ()

    // MARK: Fetching
    class func fetchProducts( machineID: Int = 3, complition: @escaping dataHandler) {
        
        let url = "\(networking.baseURL)vending/v1/machines/\(machineID)/features"
        
        firstly {
            sendDefault(request: .get, urlString: url)
        }.then { data -> Void in
            let featureModel = FeaturesModel.init(json: JSON(data))
            complition(featureModel, nil)
        }.catch { error in
            complition(nil, error)
        }
    }
    
    class func fetchFavorites(complition: @escaping dataHandler) {
        
        let url = "\(networking.baseURL)vending/v1/favorites/" //???
        
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
            complition(favorites as AnyObject? , nil)
        }.catch { error in
            complition(nil, error)
        }
    }
    
    class func fetchAccount(complition: @escaping dataHandler) {
        
        let url = "\(networking.baseURL)coins/api/v1/account"
        
        firstly {
            sendDefault(request: .get, urlString: url)
        }.then { data -> Void in
            let account = AccountModel.init(json: JSON(data))
            complition(account, nil)
        }.catch { error in
            complition(nil, error)
        }
    }
    
    typealias withImage = (_ image: UIImage) -> ()
    
    class func fetch(image urlString : String?, complition: @escaping withImage) {
        
        guard let urlString =  urlString else { return complition(UIImage(named: "Placeholder")!) }
        customManager.request("\(networking.baseURL)vending/\(urlString)")
            .responseImage { response in
                switch response.result {
                case .success(let image):
                    DataManager.imageCache.add(image, withIdentifier: urlString)
                    complition(image)
                case .failure:
                    complition(UIImage(named: "Placeholder")!)
                }
        }
    }
    
    class func buy(product identifier: Int, machineID: Int = 3, complition: @escaping dataHandler) {
        
        let url = "\(networking.baseURL)vending/v1/machines/\(machineID)/products/\(identifier)"
        
        firstly {
            sendDefault(request: .post, urlString: url)
        }.then { data -> Void in
            let json = JSON(data)
            let amount = json["amount"].intValue
            complition(amount as AnyObject?, nil)
        }.catch { error in
            complition(nil, error)
        }
    }
    
    class func favorite(_ method: Alamofire.HTTPMethod, identifier: Int, complition: @escaping dataHandler) {
        
        let url = "\(networking.baseURL)vending/v1/favorites/\(identifier)"
        
        firstly {
            sendDefault(request: method, urlString: url)
        }.then { data -> Void in
            let json = JSON(data)
            complition(json as AnyObject?, nil)
        }.catch { error in
            complition(nil, error)
        }
    }
}
