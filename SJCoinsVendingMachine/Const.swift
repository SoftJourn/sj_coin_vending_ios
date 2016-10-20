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
    
    static let baseURL = "https://sjcoins.testing.softjourn.if.ua/"
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

struct category {
    
    static let allItems = "All Items"
    static let lastAdded = "Last Added"
    static let bestSellers = "Best Sellers"
    static let cancel = "Cancel"
}

struct errorTitle {
    
    static let auth = "Authorization Error"
    static let download = "Downloading Error"
    static let buy = "Buying Error"
    static let validation = "Validation Error"
    static let reachability = "Internet Error"
}

struct errorMessage {
    
    static let validation = "Login and password should not be empty."
    static let auth = "Login failed."
    static let reachability = "Please verify your Internet connection."
    static let retryDownload = "Error held while fetching list of machines. Please try again."
}

struct buttonTitle {
    
    static let retry = "Retry"
    static let confirm = "Confirm"
    static let cancel = "Cancel"
}

struct buying {
    
    static let successTitle = "Success"
    static let failedTitle = "Failed"
    static let successMessage = "Please take your order from Vending Machine."
}

struct spinerMessage {
   
    static let downloading = "Downloading"
    static let inMessage = "Signing in ..."
    static let outMessage = "Signing out ..."
}
