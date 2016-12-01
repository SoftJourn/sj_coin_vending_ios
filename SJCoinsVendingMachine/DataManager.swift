//
//  File.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/29/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class DataManager: NSObject {
    
    // MARK: Properties
    static let shared = DataManager()

    weak var delegate: DataManagerDelegate?

    dynamic var machineId: Int { // оперувати обєктом а не параметром ІД
        get { return Defaults[.kMachineId] }
        set { Defaults[.kMachineId] = newValue }
    }
    var machineName: String {
        get { return Defaults[.kMachineName] }
        set { Defaults[.kMachineName] = newValue }
    }
    var fistLaunch: Bool {
        get { return Defaults[.fistLaunch] }
        set { Defaults[.fistLaunch] = newValue }
    }
    private(set) var machines: [MachinesModel]?
    private(set) var features: FeaturesModel?
    private(set) var account: AccountModel?
    dynamic var favorites: [Products]? {
        didSet { createCategories() }
    }
    private(set) var purchases: [PurchaseHistoryModel]?
    private(set) var categories: [Categories]!
    private(set) var allItems: [Products]?
    private(set) var lastAdded: [Products]?
    private(set) var bestSellers: [Products]?
    private(set) var unavailable: [Int]?
    
    
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
            delegate?.productsDidChange()
        case let object as AccountModel:
            account = object
        case let object as [PurchaseHistoryModel]:
            purchases = object
        default: break
        }
    }
    
    func cleanAllData() {
        
        delegate = nil
        features = nil
        account = nil
        favorites = nil
        purchases = nil
        
        categories = nil
        allItems = nil
        lastAdded = nil
        bestSellers = nil
        unavailable = nil
    }
    
    func add(favorite item: Products) {
        
        if favorites == nil {
            favorites = [Products]()
        }
        favorites?.append(item)
    }
    
    func remove(favorite item: Products) {
        
        favorites = favorites?.filter { $0.internalIdentifier != item.internalIdentifier }
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
        if !items.isEmpty {
            for item in items {
                guard let name = item.name, let products = item.products else { return }
                if !products.isEmpty {
                    let category = Categories(name: name, items: products)
                    categories.append(category)
                }
            }
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
    
    private func unavailableFavorites() {
        
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
