//
//  ProductsCategory.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/14/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation

class Categories {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    let kCategoriesProductsKey: String = "products"
    let kCategoriesNameKey: String = "name"
    
    
    // MARK: Properties
    var products: [Products]?
    var name: String?
    
    
    // MARK: SwiftyJSON Initalizers
    /**
     Initates the class based on the object
     - parameter object: The object of either Dictionary or Array kind that was passed.
     - returns: An initalized instance of the class.
     */
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }
    
    /**
     Initates the class based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public init(json: JSON) {
        products = []
        if let items = json[kCategoriesProductsKey].array {
            for item in items {
                products?.append(Products(json: item))
            }
        } else {
            products = nil
        }
        name = json[kCategoriesNameKey].string
        
    }
    
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = [ : ]
        if (products?.count)! > 0 {
            var temp: [AnyObject] = []
            for item in products! {
                temp.append(item.dictionaryRepresentation() as AnyObject)
            }
            dictionary.updateValue(temp as AnyObject, forKey: kCategoriesProductsKey)
        }
        if name != nil {
            dictionary.updateValue(name! as AnyObject, forKey: kCategoriesNameKey)
        }
        
        return dictionary
    }
    
}
