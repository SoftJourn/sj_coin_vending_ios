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
    case notAllowed
}

class ValidationManager {
    
    class func validate(login: String) -> validationStatus {
        
        if stringEmpty(login) {
            return .isEmpty
        } else {
            return stringValidation(login)
        }
    }
    
    class func validate(password: String) -> validationStatus {
        
        if stringEmpty(password) {
            return .isEmpty
        } else {
            return .success
        }
    }
    
    private class func stringEmpty(_ string: String) -> Bool {
        
        return string.isEmpty
    }
    
    private class func stringValidation(_ string: String) -> validationStatus {
        
        let regex = "[a-z^]*"
        let loginTest = NSPredicate.init(format: "SELF MATCHES %@", regex)
        
        if loginTest.evaluate(with: string) {
            return .success
        } else {
            return .notAllowed
        }
    }
}
