//
//  Helper.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 12/2/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import SystemConfiguration

class Helper {

    // MARK: Constants
    //...
    
    // MARK: Date Methods.
    class func convertDate(string: String?) -> String? {
        
        //Create date object from input string
        guard let string = string else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: string)
        
        //Convert date object to another format and create string from it
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let newDate = date else { return nil }
        let dateString = dateFormatter.string(from: newDate)
        
        return dateString
    }

    // MARK: Reachability.
    class func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
