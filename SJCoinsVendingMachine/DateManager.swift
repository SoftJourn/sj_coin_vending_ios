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
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: string)
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date!)
        
        return dateString
    }
}
