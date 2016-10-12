//
//  AuthModel.swift
//
//  Created by Oleg Pankiv on 8/17/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class AuthModel {

    // MARK: String constants
	let kAuthModelRefreshTokenKey = "refresh_token"
	let kAuthModelAccessTokenKey = "access_token"


    // MARK: Properties
	var refreshToken: String?
	var accessToken: String?


    // MARK: SwiftyJSON Initalizers
    convenience init(object: AnyObject) {
        
        self.init(json: JSON(object))
    }

    init(json: JSON) {
        
		refreshToken = json[kAuthModelRefreshTokenKey].string
		accessToken = json[kAuthModelAccessTokenKey].string
    }
}
