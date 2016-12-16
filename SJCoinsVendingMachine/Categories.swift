//
//  Categories.swift
//
//  Created by Oleg Pankiv on 10/11/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class Categories {

    // MARK: Constants
	private let keyProducts = "products"

    // MARK: Properties
	var products: [Products]?
	var name: String?

    // MARK: Initalizers
    init(_ categoryName: String, items: [Products]) {
        
        name = categoryName
        products = items
    }

    init(json: JSON) {
        
		products = []
		if let items = json[keyProducts].array {
			for item in items {
				products?.append(Products(json: item))
			}
		} else {
			products = nil
		}
		name = json[key.name].string
    }
}
