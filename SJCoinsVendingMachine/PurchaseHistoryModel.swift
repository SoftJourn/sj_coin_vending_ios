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
    private let keyTime = "time"
    
    // MARK: Properties
    var name: String?
    var price: Int?
    var time: String?
    
    // MARK: SwiftyJSON Initalizer
    init(json: JSON) {
        
        name = json[key.name].string
        price = json[key.price].int
        time = json[keyTime].string
    }
}
