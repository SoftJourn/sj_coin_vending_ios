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
        
        let regex = "[a-z^]*"
        let loginTest = NSPredicate.init(format: "SELF MATCHES %@", regex)
        
        if login.isEmpty || password.isEmpty {
            return false
        } else {
            let isValid = loginTest.evaluate(with: login)
            return isValid
        }
    }
}
