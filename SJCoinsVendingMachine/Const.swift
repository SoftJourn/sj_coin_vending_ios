//
//  Constants.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/16/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation

struct networking {
    
    //static let baseURL = "https://sjcoins-testing.softjourn.if.ua/"   //Test env
    static let baseURL = "https://vending.softjourn.if.ua/api/"          //Production env
}

struct errorMessage {
    
    static let auth = "The credentials are not correct."
    static let download = "Information could not be downloaded. Please try again later."
    static let reachability = "There is no internet connection."
    static let favorite = "Error held while adding to favorite. Please try again."
    static let available = "Chosen product is not available in current vending machine."
}

struct categoryName {
    
    static let allItems = "All Items"
    static let lastAdded = "Last Added"
    static let bestSellers = "Best Sellers"
    static let favorites = "Favorites"
    static let cancel = "Cancel"
}

struct buttonTitle {
    
    static let retry = "Retry"
    static let confirm = "Confirm"
    static let cancel = "Cancel"
}

struct spinerMessage {
    
    static let loading = "Loading..."
}

struct labels {
    
    static let noItems = "Currently there are no products in this category."
}

struct key {
    
    static let refresh = "refresh_token"
    static let name = "name"
    static let identifier = "id"
    static let amount = "amount"
    static let price = "price"
}

struct time {
    
    static let halfSecond = 0.5
}
