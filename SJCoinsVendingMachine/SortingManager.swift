//
//  SortingManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/23/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation

class SortingManager {

    private lazy var nameSegmentCounter = Int()
    private lazy var priceSegmentCounter = Int()
    private lazy var sortedData = [Products]()
    
    func sortBy(name array: [Products]?) -> [Products]? {
        
        guard let array = array else { return nil }
        priceSegmentCounter -= 1
        nameSegmentCounter += 1
        
        if nameSegmentCounter % 2 == 0 {
            sortedData = array.sorted { $1.name!.localizedCaseInsensitiveCompare($0.name!) == ComparisonResult.orderedAscending }
            return sortedData
        } else {
            sortedData = array.sorted { $0.name!.localizedCaseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending }
            return sortedData
        }
    }
    
    func sortBy(price array: [Products]?) -> [Products]? {
        
        guard let array = array else { return nil }
        nameSegmentCounter -= 1
        priceSegmentCounter += 1
        
        if priceSegmentCounter % 2 == 0 {
            sortedData = array.sorted { $0.price! > $1.price! }
            return sortedData
        } else {
            sortedData = array.sorted { $0.price! < $1.price! }
            return sortedData
        }
    }
}
