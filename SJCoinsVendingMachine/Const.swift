//
//  Constants.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/16/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct storyboards {
    
    static let tabBarControllerIdentifier = "TabBarController"
    static let settingsNavigationController = "settingsNavigationController"
    static let settingsControllerIdentifier = "settingsControllerIdentifier"
    static let allItemsViewController = "AllItemsViewController"
}

struct networking {
    
    static let baseURL = "https://sjcoins-testing.softjourn.if.ua/"
    //Auth
    static let pathAuth = "auth/oauth/token"
    static let authContentType = "application/x-www-form-urlencoded"
    static let basicKey = "dXNlcl9jcmVkOnN1cGVyc2VjcmV0"
    //Vending
    static let pathFavourites = "vending/v1/favorites/"
    static let pathProductsBeforeID = "vending/v1/machines/"
    static let pathFeatures = "/features"
    static let pathProducts = "/products"
    //Coin
    static let pathAccount = "coins/api/v1/account"
}

struct categoryName {
    
    static let allItems = "All Items"
    static let lastAdded = "Last Added"
    static let bestSellers = "Best Sellers"
    static let favorites = "Favorites"
    static let cancel = "Cancel"
}

struct myError {
    
    struct title {
        static let validation = "Validation Error"
        static let auth = "Authorization Error"
        static let download = "Downloading Error"
        static let reachability = "Internet Error"
    }
    
    struct message {
        static let validation = "Login and password should not be empty."
        static let auth = "Login failed."
        static let reachability = "Please verify your Internet connection."
        static let retryDownload = "Error held while fetching list of machines. Please try again."
    }
}

struct buttonTitle {
    
    static let retry = "Retry"
    static let confirm = "Confirm"
    static let cancel = "Cancel"
}


struct spinerMessage {
    
    static let loading = "Loading"
}

struct picture {
    
    static let placeholder = #imageLiteral(resourceName: "Placeholder")
    static let checked = #imageLiteral(resourceName: "checked")
    static let unchecked = #imageLiteral(resourceName: "unchecked")
}
