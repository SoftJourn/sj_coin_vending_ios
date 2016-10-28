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
    
    private static var isRefreshing = false
    private static var requestsToRetry: [MyRequest] = []
    private static var myPromise: Promise<AnyObject>?
    
    class func sendDefault(request method: Alamofire.HTTPMethod,
                           urlString: URLConvertible) -> Promise<AnyObject> {
        
        let headers = [ "Authorization" : "Bearer \(AuthorizationManager.getToken())"]
        let encoding = JSONEncoding.default
    
         //Create request object (with information for it retry) and save it.
        let request = MyRequest.init(method, urlString: urlString)
        requestsToRetry.append(request)
        
        myPromise = Promise<AnyObject> { fulfill, reject in
            firstly {
                sendCustom(request: method, urlString: urlString, parameters: nil, encoding: encoding, headers: headers)
            }.then { data -> Void in
                requestsToRetry.removeAll()
                fulfill(data)
            }.catch { error in
                switch error {
                case ServerError.unauthorized:
                    self.handle401StatusCode(request: request, success: fulfill, failed: reject)
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
    
    private class func handle401StatusCode(request: MyRequest, success: @escaping (AnyObject) -> Swift.Void, failed: @escaping (Error) -> Swift.Void) {
        
        SVProgressHUD.show(withStatus: spinerMessage.loading)
        if !isRefreshing {
            isRefreshing = true
            
            AuthorizationManager.refreshRequest { error in

                if error != nil {
                    print(error)
                    AuthorizationManager.removeAccessToken()
                    NavigationManager.shared.presentLoginViewController()
                }
//                self.requestsToRetry.forEach { request in
//                    //guard let method = request.method, let url = request.urlString else { return }
//                    //self.sendDefault(request: method, urlString: url)
//                }
                self.requestsToRetry.removeAll()
                self.isRefreshing = false
            
                let headers = [ "Authorization" : "Bearer \(AuthorizationManager.getToken())"]
                let encoding = JSONEncoding.default
                
                myPromise = Promise<AnyObject> { fulfill, reject in
                    firstly {
                        sendCustom(request: request.method!, urlString: request.urlString!, parameters: nil, encoding: encoding, headers: headers)
                    }.then { data -> Void in
                        success(data)
                    }.catch { error in
                        failed(error)
                    }
                }
            }
        }
    }
}

class MyRequest {
    
    var method: Alamofire.HTTPMethod?
    var urlString: URLConvertible?
    
    init(_ method: Alamofire.HTTPMethod, urlString: URLConvertible) {
        
        self.method = method
        self.urlString = urlString
    }
}
