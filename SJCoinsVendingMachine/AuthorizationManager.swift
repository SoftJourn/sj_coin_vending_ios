//
//  SJCAuthorizationManager.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/6/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

class AuthorizationManager: NetworkManager {
    
    // MARK: Constants
    fileprivate static let grantType = "password"
    typealias complited = (_ error: Error?) -> ()
    
    // MARK: Authorization
    class func authRequest(login: String, password: String, complition: @escaping complited) {
        
        //Parameters
        let URL = RequestHelper.URL.auth.string()
        let headers = RequestHelper.Headers.auth.dictionary()
        let credentialData = "username=\(login)&password=\(password)&grant_type=\(grantType)"
        
        firstly {
            sendCustomRequest(.post, urlString: URL, parameters: [:], encoding: credentialData, headers: headers)
        }.then { data -> Void in
            let model = AuthModel.init(json: JSON(data))
            TokenManager.savingAuthInfoToUserDefaults(object: model)
            complition(nil)
        }.catch { error in
            complition(error)
        }
    }
}
