//
//  Category.swift
//
//  Created by Oleg Pankiv on 10/11/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class Category {

    // MARK: String constants
	let kCategoryInternalIdentifierKey: String = "id"
	let kCategoryNameKey: String = "name"

    
    // MARK: Properties
	var internalIdentifier: Int?
	var name: String?


    // MARK: SwiftyJSON Initalizers
    convenience init(object: AnyObject) {
        
        self.init(json: JSON(object))
    }

    init(json: JSON) {
        
		internalIdentifier = json[kCategoryInternalIdentifierKey].int
		name = json[kCategoryNameKey].string

    }
}
