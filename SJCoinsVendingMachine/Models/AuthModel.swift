//
//  AuthModel.swift
//
//  Created by Oleg Pankiv on 8/17/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class AuthModel: NSObject {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	let kAuthModelRefreshTokenKey = "refresh_token"
	let kAuthModelAccessTokenKey = "access_token"


    // MARK: Properties
	var refreshToken: String?
	var accessToken: String?


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
		refreshToken = json[kAuthModelRefreshTokenKey].string
		accessToken = json[kAuthModelAccessTokenKey].string

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if refreshToken != nil {
			dictionary.updateValue(refreshToken! as AnyObject, forKey: kAuthModelRefreshTokenKey)
		}
		if accessToken != nil {
			dictionary.updateValue(accessToken! as AnyObject, forKey: kAuthModelAccessTokenKey)
		}
        return dictionary
    }
}
