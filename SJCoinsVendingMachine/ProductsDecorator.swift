//
//  ProductsDecorator.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 10/21/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation

extension Products: Equatable {
    
    static func ==(lhs: Products, rhs: Products) -> Bool {
        return lhs.internalIdentifier == rhs.internalIdentifier
    }
}
