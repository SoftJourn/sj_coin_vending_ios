//
//  Products.swift
//
//  Created by Oleg Pankiv on 10/11/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class Products:  {
    
    // MARK: String constants
    let kProductsPriceKey: String = "price"
    let kProductsDescriptionValueKey: String = "description"
    let kProductsImageUrlKey: String = "imageUrl"
    let kProductsInternalIdentifierKey: String = "id"
    let kProductsCategoryKey: String = "category"
    let kProductsNameKey: String = "name"
    
    
    // MARK: Properties
    var price: Int?
    var descriptionValue: String?
    var imageUrl: String?
    var internalIdentifier: Int?
    var category: Category?
    var name: String?
    
    
    // MARK: SwiftyJSON Initalizers
    convenience public init(object: AnyObject) {
        
        self.init(json: JSON(object))
    }
    
    public init(json: JSON) {
        
        price = json[kProductsPriceKey].int
        descriptionValue = json[kProductsDescriptionValueKey].string
        imageUrl = json[kProductsImageUrlKey].string
        internalIdentifier = json[kProductsInternalIdentifierKey].int
        category = Category(json: json[kProductsCategoryKey])
        name = json[kProductsNameKey].string
    }
    
    static func ==(lhs: Products, rhs: Products) -> Bool {
        return lhs.internalIdentifier == rhs.internalIdentifier
    }
}
