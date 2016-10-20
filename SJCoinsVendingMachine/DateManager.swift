//
//  DateManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/19/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation

class DateManager {
    
    func convertData(from string: String?) -> String? {
        
        guard let string = string else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: string)
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let newDate = date else { return nil }
        let dateString = dateFormatter.string(from: newDate)
        
        return dateString
    }
}
