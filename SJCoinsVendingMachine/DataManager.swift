//
//  File.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/29/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import SwiftyJSON
import AlamofireImage

class DataManager {
    
    //FIXME: Need to be refactored after JSON changing.
    
    // MARK: Properties
    
    fileprivate var machines: [MachinesModel]?
    fileprivate var features: FeaturesModel?
    fileprivate var account: AccountModel?
    fileprivate var favorites: [Products]?
    fileprivate var categories: [Categories]?
    
    static let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )
    
    static let shared = DataManager()

    func save(_ object: AnyObject) {
        
        switch object {
        case let object as [MachinesModel]:
            machines = object
        case let object as FeaturesModel:
            features = object
        case let object as [Products]:
            favorites = object
        case let object as AccountModel:
            account = object
        default: break
        }
    }
    
    func machinesModel() -> [MachinesModel]? {

        return machines
    }

    func accountModel() -> AccountModel? {
        
        return account
    }
    
    func favorite() -> [Products]? {
        
        return favorites
    }
    
    func category() -> [Categories]? {
        
        guard let categories = features?.categories else { return nil }
        return categories
    }
    
//    fileprivate func verifyFavorites() {
//        
//        favoriteItems.removeAll()
//        
//        if let favorites = favorites {
//            for item in favorites {
//                if let name = item.name {
//                    favoriteItems.append(name)
//                }
//            }
//        }
//    }
    
    func allItems() -> [Products]? {
        
        guard let items = features?.categories else { return nil}
        var allItemsArray = [Products]()
        
        for item in items {
            guard let products = item.products else { return nil }
            for product in products {
                allItemsArray.append(product)
            }
        }
        return allItemsArray
    }
    
//    func myLastPurchase() -> [MyLastPurchases]? {
//        return features?.myLastPurchases
//    }
//    
//    func featuresModel() -> FeaturesModel? {
//        return features
//    }
    
    func balance() -> Int? {
        
        return account?.amount
    }
    
    func saveAccount(balance amount: Int) {
        
        account?.amount = amount
    }
    
//    func favorite(_ name: String?) -> [String] {
//        
//        if name != nil {
//            if !favoriteItems.contains(name!) {
//                favoriteItems.append(name!)
//            }
//        }
//        return favoriteItems
//    }
//    
//    func unfavorite(_ name: String) {
//        
//        if let item = favoriteItems.index(of: name) {
//            favoriteItems.remove(at: item)
//        }
//    }
}
