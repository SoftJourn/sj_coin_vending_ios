//
//  MachinesModel.swift
//
//  Created by Oleg Pankiv on 10/12/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class MachinesModel {

    // MARK: Constants
	private let keySize = "size"

    // MARK: Properties
	var internalIdentifier: Int?
	var size: Size?
	var name: String?

    // MARK: Initalizers
    init(json: JSON) {
        
		internalIdentifier = json[key.identifier].int
		size = Size(json: json[keySize])
		name = json[key.name].string
    }
}
