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
    private static let grantType = "password"
    static var keychain = Keychain(service: "com.softjourn.SJCoinsVendingMachine")

    typealias complited = (_ error: Error?) -> ()
    
    // MARK: Authorization
    class func authRequest(login: String, password: String, complition: @escaping complited) {
        
        //Parameters
        let URL = "\(networking.baseURL)auth/oauth/token"
        let headers = [ "Authorization": "Basic \(networking.basicKey)",
                        "Content-Type": networking.authContentType ]
        let parameters: Parameters = ["username": login, "password" : password, "grant_type" : "password"]
        
        firstly {
            sendCustom(request: .post, urlString: URL, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers)
        }.then { data -> Void in
            let model = AuthModel.init(json: JSON(data))
            save(authInfo: model)
            complition(nil)
        }.catch { error in
            complition(error)
        }
    }
    
    class func refreshRequest(complition: @escaping complited) {
        
        let urlString = "\(networking.baseURL)auth/oauth/token"
        let headers = [ "Authorization": "Basic \(networking.basicKey)",
                        "Content-Type": networking.authContentType ]
        let parameters: Parameters = ["refresh_token": getRefreshToken(), "grant_type" : "refresh_token"]

        firstly {
            sendCustom(request: .post, urlString: urlString, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers)
        }.then { data -> Void in
            let model = AuthModel.init(json: JSON(data))
            save(authInfo: model)
            complition(nil)
        }.catch { error in
            complition(error)
        }
    }

    class func save(authInfo object: AuthModel) {
        
        guard let token = object.accessToken, let refresh = object.refreshToken else { return }
        do {
            try keychain.set(token, key: "token")
            try keychain.set(refresh, key: "refresh")
            print("Token saved")
        } catch let error {
            print(error)
        }
    }
    
    class func removeAccessToken() {
        
        do {
            try keychain.remove("token")
            print("Token removed")
        } catch let error {
            print("error: \(error)")
        }
    }
    
    class func accessTokenExist() -> Bool {
        
        guard let _ = keychain["token"] else { return false }
        //return false
        return true
    }
    
    class func getToken() -> String {
        
        guard let token = keychain["token"] else { return "" }
        return token
    }
    
    class func getRefreshToken() -> String {
        
        guard let refresh = keychain["refresh"] else { return "" }
        return refresh
    }
}
