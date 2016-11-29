//
//  ResponseHandler.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 11/2/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

enum serverError: Error {
    
    case unowned(String)
    case unauthorized
    case notEnoughCoins(String)
    case unavailableProduct(String)
    case machineLocked(String)
}

class ResponseHandler {
    
    //Error messages.
    private static let unownedMessage = "Unowned error has occurred. Please try again."
    
    //Methods.
    class func handle(_ response: Alamofire.DataResponse<Any>) -> Error {
        
        guard let statusCode = response.response?.statusCode else { return serverError.unowned(unownedMessage) }
        switch statusCode {
            
        case 401:
            return serverError.unauthorized
            
        default:
            guard let data = response.data else { return serverError.unowned(unownedMessage) }
            return ResponseHandler.handle(data)
        }
    }

    private class func handle(_ data: Data) -> Error {
        
        let json = JSON(data: data)
        let jsonMessage = json["code"]
        switch jsonMessage {
        
        case 40901:
            return serverError.notEnoughCoins("Not enough coins to buy item.")
            
        case 40404:
            return serverError.unavailableProduct("Chosen product is not available. Please refresh the page.")
            
        case 50901:
            return serverError.machineLocked("Machine is locked by queue. Try again later.")
        
        default:
            return serverError.unowned(unownedMessage)
        }
    }
}
