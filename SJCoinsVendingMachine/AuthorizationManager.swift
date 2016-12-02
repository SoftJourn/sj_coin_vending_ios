//
//  AuthorizationManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/6/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit
import SwiftyUserDefaults
import KeychainAccess


//execute via promise not via closures !


extension DefaultsKeys {
    
    static let kMachineId = DefaultsKey<Int>("machineId")
    static let kMachineName = DefaultsKey<String>("machineName")
    static let fistLaunch = DefaultsKey<Bool>("fistLaunch")
}

class AuthorizationManager: RequestManager {
    
    // MARK: Constants
    private static let tokenKey = "token"
    private static let refreshKey = "refresh"
    private static let grantTypeKey = "grant_type"
    private static let emptyString = ""
    
    static var keychain = Keychain(service: "com.softjourn.SJCoinsVendingMachine")

    typealias complited = (_ error: Error?) -> ()
    
    // MARK: Authorization
    class func authRequest(login: String, password: String, complition: @escaping complited) {
        
        let parameters: Parameters = [ "username" : login, "password" : password, grantTypeKey : "password" ]

        firstly {
            sendCustom(request: .post, urlString: urlString(), parameters: parameters, encoding: URLEncoding.httpBody, headers: headers())
        }.then { data -> Void in
            save(authInfo: AuthModel(json: JSON(data)))
            complition(nil)
        }.catch { error in
            complition(error)
        }
    }
    
    class func refreshRequest(complition: @escaping complited) {
        
        let parameters: Parameters = [ key.refresh : getRefreshToken(), grantTypeKey : key.refresh ]

        firstly {
            sendCustom(request: .post, urlString: urlString(), parameters: parameters, encoding: URLEncoding.httpBody, headers: headers())
        }.then { data -> Void in
            save(authInfo: AuthModel(json: JSON(data)))
            complition(nil)
        }.catch { error in
            complition(error)
        }
    }
    
    class func revokeRequest() -> Promise<AnyObject> {
        
        let urlString = "\(networking.baseURL)auth/oauth/token/revoke"
        let parameters: Parameters = [ "token_value" : getRefreshToken() ]
        
        let promise = Promise<AnyObject> { fulfill, reject in
            firstly {
                sendCustom(request: .post, urlString: urlString, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers())
            }.then { data in
                fulfill(data)
            }.catch { error in
                reject(error)
            }
        }
        return promise
    }
    
    class func save(authInfo object: AuthModel) {
        
        guard let token = object.accessToken, let refresh = object.refreshToken else { return }
        do {
            try keychain.set(token, key: tokenKey)
            try keychain.set(refresh, key: refreshKey)
        } catch let error {
            print(error)
        }
    }
    
    class func removeAccessToken() {
        
        do {
            try keychain.remove(tokenKey)
        } catch let error {
            print("error: \(error)")
        }
    }
    
    class func accessTokenExist() -> Bool {
        
        guard let _ = keychain[tokenKey] else { return false }
        return true
    }
    
    class func getToken() -> String {
        
        return keychain[tokenKey] != nil ? keychain[tokenKey]! : emptyString
    }
    
    class func getRefreshToken() -> String {
        
        return keychain[refreshKey] != nil ? keychain[refreshKey]! : emptyString
    }
    
    // MARK: Helper methods.
    private class func urlString() -> String {              //Authorization URL

        return "\(networking.baseURL)auth/oauth/token"
    }
    
    private class func headers() -> [String : String] {     //Authorization headers
        
        return [ "Authorization" : "Basic dXNlcl9jcmVkOnN1cGVyc2VjcmV0",
                  "Content-Type" : "application/x-www-form-urlencoded" ]
    }
}
