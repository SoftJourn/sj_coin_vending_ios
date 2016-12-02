//
//  UserDefaultsDecorator.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 12/2/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    
    static let keyMachine = DefaultsKey<MachinesModel?>("chosenMachine")
    static let fistLaunch = DefaultsKey<Bool>("fistLaunch")
}

extension UserDefaults {
    
    subscript(key: DefaultsKey<MachinesModel?>) -> MachinesModel? {
        
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}
