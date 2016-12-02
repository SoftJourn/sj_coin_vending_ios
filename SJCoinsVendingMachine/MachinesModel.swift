//
//  MachinesModel.swift
//
//  Created by Oleg Pankiv on 10/12/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class MachinesModel: NSObject, NSCoding {

    // MARK: Constants
	private let keySize = "size"

    // MARK: Properties
	var identifier: Int?
	var size: Size?
	var name: String?

    // MARK: Initalizers
    init(json: JSON) {
        
		identifier = json[key.identifier].int
		size = Size(json: json[keySize])
		name = json[key.name].string
    }
    
    required init(coder decoder: NSCoder) {
        
        identifier = decoder.decodeObject(forKey: key.identifier) as? Int
        size = decoder.decodeObject(forKey: keySize) as? Size
        name = decoder.decodeObject(forKey: key.name) as? String
    }
    
    func encode(with coder: NSCoder) {
        
        coder.encode(identifier, forKey: key.identifier)
        coder.encode(size, forKey: keySize)
        coder.encode(name, forKey: key.name)
    }
}
