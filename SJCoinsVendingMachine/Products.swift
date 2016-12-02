//
//  Products.swift
//
//  Created by Oleg Pankiv on 10/11/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class Products: NSObject {
    
    // MARK: Constants
    private let keyDescription = "description"
    private let keyImageUrl = "imageUrl"
    private let keyCategory = "category"
    
    // MARK: Properties
    var price: Int?
    var descriptionValue: String?
    var imageUrl: String?
    var internalIdentifier: Int?
    var category: Category?
    var name: String?
    
    // MARK: Initalizer
    init(json: JSON) {
        
        price = json[key.price].int
        descriptionValue = json[keyDescription].string
        imageUrl = json[keyImageUrl].string
        internalIdentifier = json[key.identifier].int
        category = Category(json: json[keyCategory])
        name = json[key.name].string
    }
}
