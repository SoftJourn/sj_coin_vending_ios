//
//  ArrayDecorator.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 11/23/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation

extension Array {
    
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
