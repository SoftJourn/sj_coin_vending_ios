//
//  Category.swift
//
//  Created by Oleg Pankiv on 10/10/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class Category: NSObject {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	let kCategoryInternalIdentifierKey: String = "id"
	let kCategoryNameKey: String = "name"


    // MARK: Properties
	var internalIdentifier: Int?
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
		internalIdentifier = json[kCategoryInternalIdentifierKey].int
		name = json[kCategoryNameKey].string

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if internalIdentifier != nil {
			dictionary.updateValue(internalIdentifier! as AnyObject, forKey: kCategoryInternalIdentifierKey)
		}
		if name != nil {
			dictionary.updateValue(name! as AnyObject, forKey: kCategoryNameKey)
		}

        return dictionary
    }

}
