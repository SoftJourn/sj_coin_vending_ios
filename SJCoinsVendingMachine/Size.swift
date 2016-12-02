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
	private let keySizeColumns = "columns"
	private let keySizeRows = "rows"

    // MARK: Properties
	var columns: Int?
	var rows: Int?

    // MARK: Initalizers
    init(json: JSON) {
        
		columns = json[keySizeColumns].int
		rows = json[keySizeRows].int
    }
}
