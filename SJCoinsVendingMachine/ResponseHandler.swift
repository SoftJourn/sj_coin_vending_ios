//
//  ResponseHandler.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 11/2/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import SwiftyJSON

enum serverError: Error {
    case unauthorized
    case notEnoughCoins(String)
}

class ResponseHandler {
    
    //Class for future custom response handling
    
    class func handle(_ data: Data?) -> Error? {
        
        guard let data = data else { return nil }
        let json = JSON(data: data)
        print(json)
        let jsonMessage = json["message"]
        switch jsonMessage {
        case "Not enough coins.":
            return serverError.notEnoughCoins("Not enough coins.")
        default:
            return nil
        }
    }
}
