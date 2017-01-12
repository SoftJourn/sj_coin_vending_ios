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
    
    // MARK: Methods
    class func validate(login: String) -> validationStatus {
        
        return login.isEmpty ? .isEmpty : stringValidation(login)
    }
    
    class func validate(password: String) -> validationStatus {
        
        return password.isEmpty ? .isEmpty : .success
    }
    
    private class func stringValidation(_ string: String) -> validationStatus {
        
        let regex = "^[a-z]*[_-]?[a-z]*$"
        let loginTest = NSPredicate.init(format: "SELF MATCHES %@", regex)
    
        return loginTest.evaluate(with: string) ? .success : .notAllowed
    }
}
