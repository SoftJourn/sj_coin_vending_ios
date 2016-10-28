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
import SVProgressHUD

enum ServerError: Error {
    case unauthorized
}

class RequestManager: BaseManager {
    
    private static var myPromise: Promise<AnyObject>?
    
    class func sendDefault(request method: Alamofire.HTTPMethod,
                           urlString: URLConvertible) -> Promise<AnyObject> {
        
        let headers = [ "Authorization" : "Bearer \(AuthorizationManager.getToken())"]
        let encoding = JSONEncoding.default
        
        myPromise = Promise<AnyObject> { fulfill, reject in
            firstly {
                sendCustom(request: method, urlString: urlString, parameters: nil, encoding: encoding, headers: headers)
                }.then { data -> Void in
                    fulfill(data)
                }.catch { error in
                    switch error {
                    case ServerError.unauthorized:
                        handle401StatusCode(method: method, url: urlString, success: fulfill, failed: reject)
                    default:
                        reject(error)
                    }
            }
        }
        return myPromise!
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
    
    private class func handle401StatusCode(method: Alamofire.HTTPMethod, url: URLConvertible, success: @escaping (AnyObject) -> Swift.Void, failed: @escaping (Error) -> Swift.Void) {
        
        AuthorizationManager.refreshRequest { error in
            
            if error != nil {
                print(error)
                AuthorizationManager.removeAccessToken()
                NavigationManager.shared.presentLoginViewController()
            }
            
            let headers = [ "Authorization" : "Bearer \(AuthorizationManager.getToken())"]
            let encoding = JSONEncoding.default
            
            myPromise = Promise<AnyObject> { fulfill, reject in
                firstly {
                    sendCustom(request: method, urlString: url, parameters: nil, encoding: encoding, headers: headers)
                    }.then { data -> Void in
                        success(data)
                    }.catch { error in
                        failed(error)
                }
            }
        }
    }
}
