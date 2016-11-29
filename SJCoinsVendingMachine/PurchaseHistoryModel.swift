//
//  PurchaseHistoryModel.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 10/20/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import SwiftyJSON

class PurchaseHistoryModel {
    
    // MARK: Constants
    let kPurchaseHistoryModelNameKey = "name"
    let kPurchaseHistoryModelPriceKey = "price"
    let kPurchaseHistoryModelTimeKey = "time"
    
    
    // MARK: Properties
    var name: String?
    var price: Int?
    var time: String?
    
    
    // MARK: SwiftyJSON Initalizers
    convenience init(object: AnyObject) {
        
        self.init(json: JSON(object))
    }
    
    init(json: JSON) {
        
        name = json[kPurchaseHistoryModelNameKey].string
        price = json[kPurchaseHistoryModelPriceKey].int
        time = json[kPurchaseHistoryModelTimeKey].string
    }
}
