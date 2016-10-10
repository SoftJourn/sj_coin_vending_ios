//
//  FeaturesModel.swift
//
//  Created by Oleg Pankiv on 8/29/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class FeaturesModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    let kFeaturesModelBestSellersKey: String = "bestSellers"
    let kFeaturesModelCategoriesKey: String = "categories"
    let kFeaturesModelLastAddedKey: String = "lastAdded"
    
    
    // MARK: Properties
    var bestSellers: [Int]?
    var categories: [Categories]?
    var lastAdded: [Int]?
    
    
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
        if let tempValue = json[kFeaturesModelBestSellersKey].array {
            bestSellers = tempValue
        } else {
            bestSellers = nil
        }
        categories = []
        if let items = json[kFeaturesModelCategoriesKey].array {
            for item in items {
                categories?.append(Categories(object: item as AnyObject))
            }
        } else {
            categories = nil
        }
        lastAdded = []
        if let items = json[kFeaturesModelLastAddedKey].array {
            for item in items {
                if let tempValue = item.int {
                    lastAdded?.append(tempValue)
                }
            }
        } else {
            lastAdded = nil
        }
        
    }
    
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = [ : ]
        if categories?.count > 0 {
            var temp: [AnyObject] = []
            for item in categories! {
                temp.append(item.dictionaryRepresentation())
            }
            dictionary.updateValue(temp, forKey: kBaseClassCategoriesKey)
        }
        if lastAdded?.count > 0 {
            dictionary.updateValue(lastAdded!, forKey: kBaseClassLastAddedKey)
        }
        
        return dictionary
    }
}
