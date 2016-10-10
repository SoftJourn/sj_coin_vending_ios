//
//  Constants.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/16/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct Storyboard {

    static let tabBarControllerIdentifier = "TabBarController"
    static let allProductsNavigationController = "AllProductsNavigationController"
}

struct category {
    static let lastAdded = "Last Added"
    static let bestSellers = "Best Sellers"
    static let snacks = "Snacks"
    static let drinks = "Drinks"
    static let allItems = "All Items"
}

struct errorTitle {
    static let auth = ""
    static let download = "Downloading Error"
    static let buy = "Buying Error"
    static let validation = "Validation Error"
    static let reachability = "Internet Error"
}

struct errorMessage {
    static let validation = "Login and password should not be empty."
    static let reachability = "Please verify your Internet connection."
}

struct buttonTitle {
    static let confirm = "Confirm"
    static let cancel = "Cancel"
}

struct buying {
    static let successTitle = "Success"
    static let failedTitle = "Failed"
    static let successMessage = "Please take your order from Vending Machine."
}