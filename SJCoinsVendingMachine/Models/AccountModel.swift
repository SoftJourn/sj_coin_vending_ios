//
//  AccountModel.swift
//
//  Created by Oleg Pankiv on 8/25/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class AccountModel {

    // MARK: String constants
    let kAccountModelAmountKey = "amount"
    let kAccountModelNameKey = "name"
    let kAccountModelSurnameKey = "surname"

    
    // MARK: Properties
	var amount: Int?
    var name: String?
    var surname: String?


    // MARK: SwiftyJSON Initalizers
    convenience init(object: AnyObject) {
        
        self.init(json: JSON(object))
    }

    init(json: JSON) {
        
		amount = json[kAccountModelAmountKey].int
        name = json[kAccountModelNameKey].string
        surname = json[kAccountModelSurnameKey].string
    }
}
