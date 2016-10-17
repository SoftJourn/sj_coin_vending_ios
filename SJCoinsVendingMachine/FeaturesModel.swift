//
//  FeaturesModel.swift
//
//  Created by Oleg Pankiv on 10/11/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class FeaturesModel {
    
    // MARK: String constants
    let kFeaturesModelBestSellersKey: String = "bestSellers"
    let kFeaturesModelCategoriesKey: String = "categories"
    let kFeaturesModelLastAddedKey: String = "lastAdded"
    
    
    // MARK: Properties
    var bestSellers: [Int]?
    var categories: [Categories]?
    var lastAdded: [Int]?
    
    
    // MARK: SwiftyJSON Initalizers
    convenience init(object: AnyObject) {
        
        self.init(json: JSON(object))
    }
    
    init(json: JSON) {
        
        bestSellers = []
        if let items = json[kFeaturesModelBestSellersKey].array {
            for item in items {
                if let tempValue = item.int {
                    lastAdded?.append(tempValue)
                }
            }
        } else {
            bestSellers = nil
        }
        categories = []
        if let items = json[kFeaturesModelCategoriesKey].array {
            for item in items {
                categories?.append(Categories(json: item))
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
}
