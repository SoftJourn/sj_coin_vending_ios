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
    
    //Wrapped abstract network method. Used by AuthorizationManager.
    class func sendCustom(request method: Alamofire.HTTPMethod,
                          urlString: URLConvertible,
                          parameters: Parameters?,
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

    //Wrapped sendCustom method. Used by APIManager.
    class func sendDefault(request method: Alamofire.HTTPMethod,
                           urlString: URLConvertible) -> Promise<AnyObject> {
        
        let promise = Promise<AnyObject> { fulfill, reject in
            firstly {
                sendCustom(request: method, urlString: urlString, parameters: nil, encoding: JSONEncoding.default, headers: headers())
            }.then { data -> Void in
                fulfill(data)
            }.catch { error in
                switch error {
                case serverError.unauthorized:
                    handle401StatusCode(method: method, url: urlString, success: fulfill, failed: reject)
                default:
                    reject(error)
                }
            }
        }
        return promise
    }
    
    private class func handle401StatusCode(method: Alamofire.HTTPMethod, url: URLConvertible, success: @escaping (AnyObject) -> Swift.Void, failed: @escaping (Error) -> Swift.Void) {
        
        AuthorizationManager.refreshRequest { error in

            if error != nil {
                print(error!)
                AuthorizationManager.removeAccessToken()
                NavigationManager.shared.presentInformativePageViewController(firstTime: false)
            }
            
            _ = Promise<AnyObject> { fulfill, reject in
                firstly {
                    sendCustom(request: method, urlString: url, parameters: nil, encoding: JSONEncoding.default, headers: headers())
                }.then { data -> Void in
                    success(data)
                }.catch { error in
                    failed(error)
                }
            }
        }
    }
    
    // MARK: Helper methods.
    private class func headers() -> [String : String] {
        
        return [ "Authorization" : "Bearer \(AuthorizationManager.getToken())" ]
    }
}
