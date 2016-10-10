//
//  Products.swift
//
//  Created by Oleg Pankiv on 10/10/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class Products {

    // MARK: Declaration for string constants to be used to decode and also serialize.
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
		price = json[kProductsPriceKey].int
		descriptionValue = json[kProductsDescriptionValueKey].string
		imageUrl = json[kProductsImageUrlKey].string
		internalIdentifier = json[kProductsInternalIdentifierKey].int
		category = Category(json: json[kProductsCategoryKey])
		name = json[kProductsNameKey].string

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if price != nil {
			dictionary.updateValue(price! as AnyObject, forKey: kProductsPriceKey)
		}
		if descriptionValue != nil {
			dictionary.updateValue(descriptionValue! as AnyObject, forKey: kProductsDescriptionValueKey)
		}
		if imageUrl != nil {
			dictionary.updateValue(imageUrl! as AnyObject, forKey: kProductsImageUrlKey)
		}
		if internalIdentifier != nil {
			dictionary.updateValue(internalIdentifier! as AnyObject, forKey: kProductsInternalIdentifierKey)
		}
		if category != nil {
			dictionary.updateValue(category!.dictionaryRepresentation() as AnyObject, forKey: kProductsCategoryKey)
		}
		if name != nil {
			dictionary.updateValue(name! as AnyObject, forKey: kProductsNameKey)
		}

        return dictionary
    }

}
