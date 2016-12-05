//
//  SortingManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/23/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

//FIXME: Comments, elements unwrapping!

import Foundation

class SortingHelper {
    
    private var nameSegmentCounter = Int()
    private var priceSegmentCounter = Int()
    
    private enum counter {
        
        case name
        case price
    }
    
    func sortBy(name array: [Products]?, state: Bool?) -> [Products]? {
        
        guard let array = array else { return nil }
        change(counter.name, for: state)
        return nameSegmentCounter % 2 != 0
        ? array.sorted { $1.name!.localizedCaseInsensitiveCompare($0.name!) == ComparisonResult.orderedAscending }
        : array.sorted { $0.name!.localizedCaseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending }
    }
    
    func sortBy(price array: [Products]?, state: Bool?) -> [Products]? {
        
        guard let array = array else { return nil }
        change(counter.price, for: state)
        return priceSegmentCounter % 2 != 0 ? array.sorted { $0.price! > $1.price! } : array.sorted { $0.price! < $1.price! }
    }
    
    private func change(_ couter: counter, for state: Bool?) {
        
        if state != nil {
            switch couter {
            case .name:
                if state! {
                    nameSegmentCounter += 1
                }
            case .price:
                if state! {
                    priceSegmentCounter += 1
                }
            }
        }
    }
}
