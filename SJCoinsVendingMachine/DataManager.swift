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
import SwiftyUserDefaults

class DataManager: NSObject {
    
    // MARK: Properties
    dynamic var machineId: Int {
        get { return Defaults[.kMachineId] }
        set { Defaults[.kMachineId] = newValue }
    }
    
    private(set) var machines: [MachinesModel]?
    private(set) var features: FeaturesModel?
    private(set) var account: AccountModel?
    private(set) var favorites: [Products]? /*{
        didSet { createCategories() }
    }
    */
    private(set) var purchases: [PurchaseHistoryModel]?
    
    private(set) var categories: [Categories]!
    private(set) var allItems: [Products]?
    private(set) var lastAdded: [Products]?
    private(set) var bestSellers: [Products]?
    
    private(set) var unavailable: [Int]?
    
    // MARK: Static Properties
    static let shared = DataManager()
    static let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )
    
    // MARK: Setters
    func save(_ object: AnyObject) {
        
        switch object {
        case let object as [MachinesModel]:
            machines = object
        case let object as FeaturesModel:
            features = object
            createAllItems()
            createLastAdded()
            createBestSellers()
            createCategories()
            unavailableFavorites()
        case let object as [Products]:
            favorites = object
        case let object as AccountModel:
            account = object
        case let object as [PurchaseHistoryModel]:
            purchases = object
        default: break
        }
    }
    
    func add(favorite item: Products) {
        
        if favorites == nil {
            favorites = [Products]()
        }
        favorites?.append(item)

        categories.forEach { category in
            if category.name == categoryName.favorites {
                guard var favoriteProducts = category.products else { return }
                favoriteProducts.append(item)
            }
        }
    }
    
    func remove(favorite item: Products) {
        
        guard let favoritesItems = favorites else { return }
        favorites = favoritesItems.filter { $0 != item }
        dump(favorites)
    }
    
    func save(balance amount: Int) {
        
        account?.amount = amount
    }
    
    //Prepearing methods
    private func createCategories() {
        
        categories = [Categories]()
        
        if let favorites = favorites {
            if !favorites.isEmpty {
                let category = Categories(name: categoryName.favorites, items: favorites)
                categories.append(category)
            }
        }
        guard let features = features, let lastAdded = lastAdded else { return }
        if !lastAdded.isEmpty {
            let category = Categories(name: categoryName.lastAdded, items: lastAdded)
            categories.append(category)
        }
        guard let bestSellers = bestSellers else { return }
        if !bestSellers.isEmpty {
            let category = Categories(name: categoryName.bestSellers, items: bestSellers)
            categories.append(category)
        }
        guard let items = features.categories else { return }
        for item in items {
            guard let name = item.name, let products = item.products else { return }
            let category = Categories(name: name, items: products)
            categories.append(category)
        }
    }
    
    private func createAllItems() {
        
        guard let items = features?.categories else { return }
        allItems = [Products]()
        for item in items {
            guard let products = item.products else { return }
            for product in products {
                allItems!.append(product)
            }
        }
    }
    
    private func createLastAdded() {
        
        guard let items = features?.lastAdded else { return }
        lastAdded = [Products]()
        guard let categories = features?.categories else { return }
        for category in categories {
            guard let products = category.products else { return }
            for product in products {
                guard let id = product.internalIdentifier else { return }
                if items.contains(id) {
                    lastAdded!.append(product)
                }
            }
        }
    }
    
    private func createBestSellers() {
        
        guard let items = features?.bestSellers else { return }
        bestSellers = [Products]()
        guard let categories = features?.categories else { return }
        for category in categories {
            guard let products = category.products else { return }
            for product in products {
                guard let id = product.internalIdentifier else { return }
                if items.contains(id) {
                    bestSellers!.append(product)
                }
            }
        }
    }
    
    func unavailableFavorites() {
        
        if unavailable == nil {
            unavailable = [Int]()
        }
        unavailable?.removeAll()
        var allProducts = Set<Int>()
        if let dynamicCategories = features?.categories {
            for category in dynamicCategories {
                guard let products = category.products else { return }
                for product in products {
                    guard let identifier = product.internalIdentifier else { return }
                    allProducts.insert(identifier)
                }
            }
        }
        var favoriteProducts = Set<Int>()
        guard let favorites = favorites else { return }
        for product in favorites {
            guard let identifier = product.internalIdentifier else { return }
            favoriteProducts.insert(identifier)
        }
        for product in favoriteProducts {
            if !allProducts.contains(product) {
                unavailable?.append(product)
            }
        }
    }
}
