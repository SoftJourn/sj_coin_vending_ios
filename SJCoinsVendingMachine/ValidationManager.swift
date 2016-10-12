//
//  ValidationManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/17/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation

class ValidationManager {
    
    class func validate(login: String, password: String) -> Bool {
        return login.isEmpty || password.isEmpty
    }
}
