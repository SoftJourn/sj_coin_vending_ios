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
        case let object as FeaturesModel:
            features = object
        case let object as [Products]:
            favorites = object
        case let object as AccountModel:
            account = object
        default: break
        }
    }
    
//    func createCategories() -> [Category]? {
//        
//        categories = [Category]()
//        
//        if let newProducts = features?.newProducts {
//            if newProducts.count > 0 {
//                categories?.append(Category.init(name: category.lastAdded, items: newProducts))
//            }
//        }
//        if let bestSellers = features?.bestSellers {
//            if bestSellers.count > 0 {
//                categories?.append(Category.init(name: category.bestSellers, items: bestSellers))
//            }
//        }
//        if let snacks = features?.snack {
//            if snacks.count > 0 {
//                categories?.append(Category.init(name: category.snacks, items: snacks))
//            }
//        }
//        if let drinks = features?.drink {
//            if drinks.count > 0 {
//                categories?.append(Category.init(name: category.drinks, items: drinks))
//            }
//        }
//        return categories
//    }
    
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
    
//    func allItemsArray() -> [Products]? {
//        
//        guard let featureModel = features,
//            let drink = featureModel.drink,
//            let snack = featureModel.snack else { return nil}
//        var products = [Product]()
//        for object in snack {
//            products.append(object as Product)
//        }
//        for object in drink {
//            products.append(object as Product)
//        }
//        return products
//    }
    
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
