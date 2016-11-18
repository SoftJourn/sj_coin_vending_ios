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
    static let unownedMessage = "Unowned error has occurred. Please try again." //unhandled error has occurred.
    static let notEnoughCoinsMessage = "Not enough coins to buy item."
    static let unavailableProductMessage = "Chosen product is not available. Please refresh the page."
    static let machineLockedMessage = "Machine is locked by queue. Try again later."
    
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
            return serverError.notEnoughCoins(notEnoughCoinsMessage)
            
        case 40404:
            return serverError.unavailableProduct(unavailableProductMessage)
            
        case 50901:
            return serverError.machineLocked(machineLockedMessage)
        
        default:
            return serverError.unowned(unownedMessage)
        }
    }
}
