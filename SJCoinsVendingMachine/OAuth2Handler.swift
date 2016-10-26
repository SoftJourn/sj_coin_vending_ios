//
//  OAuth2Handler.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/27/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD
import SwiftyJSON

class OAuth2Handler: RequestRetrier {
    
    // MARK: Properties
    private var isRefreshing = false
    private var requestsToRetry: [Request] = []
    
    // MARK: Retrier
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        //
        let code = request.task?.response as? HTTPURLResponse
        print("\(code?.statusCode)")
        //
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(request)
            handle401StatusCode { completion($0, $1) } // $0 - shouldRetry parameter, $1 - timeDelay parameter.
        }
    }
    
    private func handle401StatusCode(completion: @escaping RequestRetryCompletion) {
        
        if !isRefreshing {
            //SVProgressHUD.show(withStatus: spinerMessage.loading)
            isRefreshing = true
            
            AuthorizationManager.refreshRequest { [unowned self] error in
                if error != nil {
                    AuthorizationManager.removeAccessToken()
                    NavigationManager.shared.presentLoginViewController()
                }
                self.requestsToRetry.forEach { request in
                    var req = request.request
                    let newToken = AuthorizationManager.getToken()
                    //FIXME: Need investigate token change.
                    req?.setValue("Bearer \(newToken)", forHTTPHeaderField: "Authorization")
                    completion(false, 0.0) // don't retry
                }
                self.requestsToRetry.removeAll()
                self.isRefreshing = false
                SVProgressHUD.dismiss(withDelay: 0.5)
                completion(false, 0.0) // don't retry
            }
        }
    }
}
