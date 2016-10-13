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

extension DefaultsKeys {
    
    static let kAccessToken = DefaultsKey<String>("access_token")
    static let kRefreshToken = DefaultsKey<String>("refresh_token")
    static let kMachineId = DefaultsKey<Int>("machineId")
}

class AuthorizationManager: RequestManager {
    
    // MARK: Constants
    fileprivate static let grantType = "password"
    typealias complited = (_ error: Error?) -> ()
    
    // MARK: Authorization
    class func authRequest(login: String, password: String, complition: @escaping complited) {
        
        //Parameters
        let URL = "\(networking.baseURL)auth/oauth/token"
        let headers = [ "Authorization": "Basic \(networking.basicKey)",
                        "Content-Type": networking.authContentType ]
        let credentialData = "username=\(login)&password=\(password)&grant_type=\(grantType)"
        
        firstly {
            sendCustom(request: .post, urlString: URL, parameters: [:], encoding: credentialData, headers: headers)
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
        let refreshData = "refresh_token=\(Defaults[.kRefreshToken])&grant_type=refresh_token"
        
        customManager.request(urlString, method: .post, parameters: [:], encoding: refreshData, headers: headers)
            .responseJSON { response in
                
                switch response.result {
                case .success(let data):
                    //print(data)
                    let model = AuthModel.init(json: JSON(data))
                    save(authInfo: model)
                    complition(nil)
                case .failure(let error):
                    complition(error)
                }
        }
    }

    class func save(authInfo object: AuthModel) {
        
        guard let token = object.accessToken, let refresh = object.refreshToken else { return }
        Defaults[.kAccessToken] = token
        Defaults[.kRefreshToken] = refresh
        print("Token saved")
        //print(object.expiresIn)
        //print("REFRESH: \(Defaults[.kRefreshToken])")
        //print("ACCESS: \(Defaults[.kAccessToken])")
    }
    
    class func save(machineId: Int) {
        
        Defaults[.kMachineId] = machineId
    }
    
    class func getMachineId() -> Int {
        
        return Defaults[.kMachineId]
    }

    
    class func removeAccessToken() {
        
        Defaults.remove(.kAccessToken)
        print("Token removed")
    }
    
    class func update(authInfo token: String, refresh: String) {
        
        Defaults[.kAccessToken] = token
        Defaults[.kRefreshToken] = refresh
    }
    
    class func accessTokenExist() -> Bool {
        
        return Defaults.hasKey(.kAccessToken)
    }
    
    class func getToken() -> String {
        
        return Defaults[.kAccessToken]
    }
    
    class func getRefreshToken() -> String {
        
        return Defaults[.kRefreshToken]
    }
}
