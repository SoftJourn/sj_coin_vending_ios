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
    
    private typealias refreshComplited = (_ model: AuthModel?, _ error: Error?) -> ()
    
    // MARK: Properties
    private var isRefreshing = false
    private var requestsToRetry: [Request] = []
    private let lock = NSLock()
    
    // MARK: Retrier
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        SVProgressHUD.show(withStatus: spinerMessage.loading)
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(request)
            
            if !isRefreshing {
                
                isRefreshing = true
                AuthorizationManager.refreshRequest { [weak self] model, error in
                    
                    guard let strongSelf = self else { return }
                    strongSelf.lock.lock();  defer { strongSelf.lock.unlock() }
                    
                    strongSelf.isRefreshing = false
                    SVProgressHUD.dismiss(withDelay: 0.5)
                    
                    if model != nil {
                        AuthorizationManager.save(authInfo: model!)
                        for request in strongSelf.requestsToRetry {
                            //For all requests in array change access token, and run them. 
                            var req = request.request
                            req?.setValue("Bearer \(model?.accessToken)", forHTTPHeaderField: "Authorization")
                            completion(false, 0.0)
                        }
                        strongSelf.requestsToRetry.removeAll()
                        completion(false, 0.0) // retry after 1 second
                    } else {
                        //If refresh token invalig (users more than month not use application) show login page.
                        completion(true, 1.0) // retry after 1 second
                    }
                }
            }
        } else {
            completion(false, 0.0) // don't retry
        }
    }
}
