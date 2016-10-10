//
//  RequestManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/4/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class RequestManager: BaseManager {
    
    class func sendDefault(request method: Alamofire.HTTPMethod,
                                  urlString: URLConvertible) -> Promise<AnyObject> {
        
        let headers = [ "Authorization" : "Bearer \(AuthorizationManager.getToken())"]
        let encoding = JSONEncoding.default
        
        let promise = Promise<AnyObject> { fulfill, reject in
            firstly {
                sendCustom(request: method, urlString: urlString, parameters: nil, encoding: encoding, headers: headers)
            }.then { data in
                fulfill(data)
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
    
    class func sendCustom(request method: Alamofire.HTTPMethod,
                                 urlString: URLConvertible,
                                 parameters: [String: AnyObject]?,
                                 encoding: ParameterEncoding,
                                 headers: Dictionary<String, String>) -> Promise<AnyObject> {
        
        let promise = Promise<AnyObject> { fulfill, reject in
            firstly {
                sendRequest(urlString, method: method, parameters: parameters, encoding: encoding, headers: headers)
            }.then { data in
                fulfill(data)
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
}
