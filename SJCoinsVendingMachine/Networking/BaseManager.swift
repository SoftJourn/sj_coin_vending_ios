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
        
        return Alamofire.SessionManager(configuration: sessionConfiguration(), serverTrustPolicyManager: securityConfiguration())
    }()
    
    class func securityConfiguration() -> ServerTrustPolicyManager {
        
        //Security configuration the Alamofire manager.
        let coinServer = "sjcoins-testing.softjourn.if.ua"
        let resource = "coin"
        let type = "cer"
        
        guard let pathToCert = Bundle.main.path(forResource: resource, ofType: type), let certificateData = NSData(contentsOfFile: pathToCert), let certificate = SecCertificateCreateWithData(nil, certificateData) else {
            //Use DefaultEvaluation.
            return ServerTrustPolicyManager(policies: [ coinServer: .performDefaultEvaluation(validateHost: true) ])
        }
        let serverTrustPolicy = ServerTrustPolicy.pinCertificates(
            // Getting the certificate from the certificate data
            certificates: [certificate],
            // Choose to validate the complete certificate chain, not only the certificate itself
            validateCertificateChain: true,
            // Check that the certificate mathes the host who provided it
            validateHost: true
        )
        
        //Use CustomEvaluation.
        return ServerTrustPolicyManager(policies: [ coinServer: serverTrustPolicy ])
    }
    
    class func sessionConfiguration() -> URLSessionConfiguration {
        
        //Session configuration of the Alamofire manager.
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15 //seconds
        configuration.timeoutIntervalForResource = 15 //seconds
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        return configuration
    }
    
    //Abstract method for network calls.
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
                    case .failure:
                        reject(ResponseHandler.handle(response))
                    }
            }
        }
        return promise
    }
}
