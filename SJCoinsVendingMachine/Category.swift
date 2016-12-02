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
	let keyName = "name"
    
    // MARK: Properties
	var internalIdentifier: Int?
	var name: String?

    // MARK: Initalizer
    init(json: JSON) {
        
		internalIdentifier = json[key.identifier].int
		name = json[keyName].string
    }
}
