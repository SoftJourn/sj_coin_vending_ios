//
//  AuthModel.swift
//
//  Created by Oleg Pankiv on 8/17/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class AuthModel {

    // MARK: Constants
	private let keyAccessToken = "access_token"

    // MARK: Properties
	var refreshToken: String?
	var accessToken: String?

    // MARK: Initalizers
    init(json: JSON) {
        
		refreshToken = json[key.refresh].string
		accessToken = json[keyAccessToken].string
    }
}
