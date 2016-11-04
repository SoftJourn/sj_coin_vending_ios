//
//  BaseManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/4/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class BaseManager {
    
    // MARK: Properties
    static let customManager: Alamofire.SessionManager = {
        
        //Privacy configuration the Alamofire manager
        let serverTrustPolicies: [String: ServerTrustPolicy] = [ "sjcoins-testing.softjourn.if.ua": .disableEvaluation ]
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 //seconds
        configuration.timeoutIntervalForResource = 30 //seconds
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        let manager = Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return manager
    }()
    
    class func sendRequest(_ urlString: URLConvertible,
                           method: Alamofire.HTTPMethod,
                           parameters: Parameters?,
                           encoding: ParameterEncoding,
                           headers: Dictionary<String, String>) -> Promise<AnyObject> {
        
        let promise = Promise<AnyObject> { fulfill, reject in
            
            customManager.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate()
                .responseJSON { response in
                    debugPrint(response)
                    switch response.result {
                    case .success(let json):
                        fulfill(json as AnyObject)
                    case .failure(let error):
                        if response.response?.statusCode == 401 {
                            reject(serverError.unauthorized)
                        } else if response.response?.statusCode == 409 {
                            guard let data = response.data else { return }
                            let error = ResponseHandler.handle(data)
                            if error != nil {
                                reject(error!)
                            }
                        } else {
                            _ = ResponseHandler.handle(response.data)
                            reject(error)
                        }
                    }
            }
        }
        return promise
    }
    
}
