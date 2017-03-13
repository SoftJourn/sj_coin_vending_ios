//
//  ValidationManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/17/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation

enum validationStatus {
    
    case success
    case isEmpty
}

class ValidationManager {
    
    // MARK: Methods
    class func validate(string: String) -> validationStatus {
        
        return string.isEmpty ? .isEmpty : .success
    }
}
