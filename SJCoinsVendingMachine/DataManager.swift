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
    
    deinit {
        
        print("DataManager deinited")
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
    
    func allItems() -> [Products]? {
        
        guard let items = features?.categories else { return nil }
        var allItemsArray = [Products]()
        
        for item in items {
            guard let products = item.products else { return nil }
            for product in products {
                allItemsArray.append(product)
            }
        }
        return allItemsArray
    }
    
    func lastAdded() -> [Products]? {
        
        guard let items = features?.lastAdded else { return nil }
        var lastAdded = [Products]()
        guard let categories = category() else { return nil }
        for category in categories {
            guard let products = category.products else { return nil }
            for product in products {
                guard let id = product.internalIdentifier else { return nil }
                if items.contains(id) {
                    lastAdded.append(product)
                }
            }
        }
        return lastAdded
    }
    
    func bestSellers() -> [Products]? {
        
        guard let items = features?.bestSellers else { return nil }
        var bestSellers = [Products]()
        guard let categories = category() else { return nil }
        for category in categories {
            guard let products = category.products else { return nil }
            for product in products {
                guard let id = product.internalIdentifier else { return nil }
                if items.contains(id) {
                    bestSellers.append(product)
                }
            }
        }
        dump(bestSellers)
        return bestSellers
    }
    
    //    func myLastPurchase() -> [MyLastPurchases]? {
    //        return features?.myLastPurchases
    //    }
    //
    
    func balance() -> Int? {
        
        return account?.amount
    }
    
    func saveAccount(balance amount: Int) {
        
        account?.amount = amount
    }
}
