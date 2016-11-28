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

extension DefaultsKeys {
    
    static let kMachineId = DefaultsKey<Int>("machineId")
    static let kMachineName = DefaultsKey<String>("machineName")
    static let fistLaunch = DefaultsKey<Bool>("fistLaunch")
}

class AuthorizationManager: RequestManager {
    
    // MARK: Constants
    private static let authorizationKey = "Authorization"
    private static let contentTypeKey = "Content-Type"
    private static let usernameKey = "username"
    private static let passwordKey = "password"
    private static let grantTypeKey = "grant_type"
    private static let grantTypePassword = "password"
    private static let grantTypeRefresh = "refresh_token"
    private static let tokenKey = "token"
    private static let refreshKey = "refresh"

    static var keychain = Keychain(service: "com.softjourn.SJCoinsVendingMachine")

    typealias complited = (_ error: Error?) -> ()
    
    // MARK: Authorization
    class func authRequest(login: String, password: String, complition: @escaping complited) {
        
        let parameters: Parameters = [ usernameKey : login, passwordKey : password, grantTypeKey : grantTypePassword ]
        
        firstly {
            sendCustom(request: .post, urlString: urlString(), parameters: parameters, encoding: URLEncoding.httpBody, headers: headers())
        }.then { data -> Void in
            let model = AuthModel.init(json: JSON(data))
            save(authInfo: model)
            complition(nil)
        }.catch { error in
            complition(error)
        }
    }
    
    class func refreshRequest(complition: @escaping complited) {
        
        let parameters: Parameters = [ grantTypeRefresh : getRefreshToken(), grantTypeKey : grantTypeRefresh ]

        firstly {
            sendCustom(request: .post, urlString: urlString(), parameters: parameters, encoding: URLEncoding.httpBody, headers: headers())
        }.then { data -> Void in
            let model = AuthModel.init(json: JSON(data))
            save(authInfo: model)
            complition(nil)
        }.catch { error in
            complition(error)
        }
    }
    
    private class func urlString() -> String {
        
        return "\(networking.baseURL)auth/oauth/token"
    }
    
    private class func headers() -> [String : String] {
        
        return [ authorizationKey : "Basic \(networking.basicKey)",
                   contentTypeKey : networking.authContentType ]
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
            try keychain.remove("token")
        } catch let error {
            print("error: \(error)")
        }
    }
    
    class func accessTokenExist() -> Bool {
        
        guard let _ = keychain["token"] else { return false }
        return true
    }
    
    class func getToken() -> String {
        
        return keychain["token"] != nil ? keychain["token"]! : ""
    }
    
    class func getRefreshToken() -> String {
        
        return keychain["refresh"] != nil ? keychain["refresh"]! : ""
    }
}
