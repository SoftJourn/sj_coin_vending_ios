//
//  FeaturesModel.swift
//
//  Created by Oleg Pankiv on 10/11/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class FeaturesModel {
    
    // MARK: Constants
    private let keyBestSellers = "bestSellers"
    private let keyCategories = "categories"
    private let keyLastAdded = "lastAdded"
    
    // MARK: Properties
    var bestSellers: [Int]?
    var categories: [Categories]?
    var lastAdded: [Int]?
    
    // MARK: Initalizers
    init(json: JSON) {
        //FIXME: Need refactoring
        bestSellers = []
        if let items = json[keyBestSellers].array {
            for item in items {
                if let tempValue = item.int {
                    bestSellers?.append(tempValue)
                }
            }
        } else {
            bestSellers = nil
        }
        categories = []
        if let items = json[keyCategories].array {
            for item in items {
                categories?.append(Categories(json: item))
            }
        } else {
            categories = nil
        }
        lastAdded = []
        if let items = json[keyLastAdded].array {
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
