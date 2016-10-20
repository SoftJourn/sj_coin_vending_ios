//
//  Categories.swift
//
//  Created by Oleg Pankiv on 10/11/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class Categories {

    // MARK:String constants
	let kCategoriesProductsKey: String = "products"
	let kCategoriesNameKey: String = "name"


    // MARK: Properties
	var products: [Products]?
	var name: String?


    // MARK: SwiftyJSON Initalizers
    init(name: String, items: [Products]) {
        
        self.name = name
        self.products = items
    }
    
    convenience init(object: AnyObject) {
        
        self.init(json: JSON(object))
    }

    init(json: JSON) {
        
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
}
