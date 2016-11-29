//
//  Size.swift
//
//  Created by Oleg Pankiv on 10/12/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class Size {

    // MARK: Constants
	let kSizeColumnsKey: String = "columns"
	let kSizeRowsKey: String = "rows"


    // MARK: Properties
	var columns: Int?
	var rows: Int?


    // MARK: SwiftyJSON Initalizers
    convenience  init(object: AnyObject) {
        
        self.init(json: JSON(object))
    }

    init(json: JSON) {
        
		columns = json[kSizeColumnsKey].int
		rows = json[kSizeRowsKey].int
    }
}
