//
//  AccountModel.swift
//
//  Created by Oleg Pankiv on 8/25/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class AccountModel {

    // MARK: Constants
    private let keySurname = "surname"
    
    // MARK: Properties
	var amount: Int?
    var name: String?
    var surname: String?

    // MARK: Initalizers
    init(json: JSON) {
        
		amount = json[key.amount].int
        name = json[key.name].string
        surname = json[keySurname].string
    }
}
