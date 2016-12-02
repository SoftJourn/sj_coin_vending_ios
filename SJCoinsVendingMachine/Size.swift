//
//  Size.swift
//
//  Created by Oleg Pankiv on 10/12/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class Size: NSObject, NSCoding {

    // MARK: Constants
	private let keyColumns = "columns"
	private let keyRows = "rows"

    // MARK: Properties
	var columns: Int?
	var rows: Int?

    // MARK: Initalizers
    init(json: JSON) {
        
		columns = json[keyColumns].int
		rows = json[keyRows].int
    }
    
    required init(coder decoder: NSCoder) {
        
        columns = decoder.decodeObject(forKey: keyColumns) as? Int
        rows = decoder.decodeObject(forKey: keyRows) as? Int
    }
    
    func encode(with coder: NSCoder) {
        
        coder.encode(columns, forKey: keyColumns)
        coder.encode(rows, forKey: keyRows)
    }
}
