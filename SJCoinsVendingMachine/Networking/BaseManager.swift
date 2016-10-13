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
        let serverTrustPolicies: [String: ServerTrustPolicy] = [ "sjcoins.testing.softjourn.if.ua": .disableEvaluation ]
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 //seconds
        configuration.timeoutIntervalForResource = 30 //seconds
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()
    
    class func sendRequest(_ urlString: URLConvertible,
                                       method: Alamofire.HTTPMethod,
                                       parameters: [String: AnyObject]?,
                                       encoding: ParameterEncoding,
                                       headers: Dictionary<String, String>) -> Promise<AnyObject> {
        
        //let oauthHandler = OAuth2Handler.init(baseURLString: Networking.baseURL, accessToken: AuthorizationManager.getToken(), refreshToken: AuthorizationManager.getRefreshToken())
        //customManager.retrier = oauthHandler
        
        let promise = Promise<AnyObject> { fulfill, reject in
            customManager.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        fulfill(json as AnyObject)
                    case .failure(let error):
                        guard let data = response.data else { return }
                        let errorData = NSString(data: data, encoding:String.Encoding.utf8.rawValue)
                        print(errorData)
                        reject(error)
                    }
            }
        }
        return promise
    }
}
