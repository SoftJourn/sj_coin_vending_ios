//
//  MachinesModel.swift
//
//  Created by Oleg Pankiv on 10/12/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class MachinesModel {

    // MARK: String constants
	let kMachinesModelInternalIdentifierKey: String = "id"
	let kMachinesModelSizeKey: String = "size"
	let kMachinesModelNameKey: String = "name"


    // MARK: Properties
	var internalIdentifier: Int?
	var size: Size?
	var name: String?


    // MARK: SwiftyJSON Initalizers
    convenience init(object: AnyObject) {
        
        self.init(json: JSON(object))
    }

    init(json: JSON) {
        
		internalIdentifier = json[kMachinesModelInternalIdentifierKey].int
		size = Size(json: json[kMachinesModelSizeKey])
		name = json[kMachinesModelNameKey].string
    }
}
