//
//  AccountModel.swift
//
//  Created by Oleg Pankiv on 8/25/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class AccountModel: NSObject {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	let kAccountModelAmountKey = "amount"
    let kAccountModelNameKey = "name"
    let kAccountModelSurnameKey = "surname"

    
    // MARK: Properties
	var amount: Int?
    var name: String?
    var surname: String?


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
		amount = json[kAccountModelAmountKey].int
        name = json[kAccountModelNameKey].string
        surname = json[kAccountModelSurnameKey].string

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if amount != nil {
			dictionary.updateValue(amount! as AnyObject, forKey: kAccountModelAmountKey)
		}
        if name != nil {
            dictionary.updateValue(name! as AnyObject, forKey: kAccountModelNameKey)
        }
        if surname != nil {
            dictionary.updateValue(surname! as AnyObject, forKey: kAccountModelSurnameKey)
        }

        return dictionary
    }
}
