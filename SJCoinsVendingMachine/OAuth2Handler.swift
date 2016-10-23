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

class OAuth2Handler: RequestRetrier {
    
    fileprivate typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
    
    // MARK: Properties
    fileprivate var isRefreshing = false
    fileprivate var requestsToRetry: [RequestRetryCompletion] = []
    fileprivate let lock = NSLock()
    
    // MARK: - RequestRetrier
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        SVProgressHUD.show(withStatus: spinerMessage.loading)
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                AuthorizationManager.refreshRequest { [weak self] model, error in
                    guard let strongSelf = self else { return }
                    strongSelf.isRefreshing = true

                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    guard model != nil else {
                        strongSelf.isRefreshing = false
                        SVProgressHUD.dismiss(withDelay: 0.5)
                        print("refresh token failed \(error?.localizedDescription)")
                        completion(true, 1.0) // retry
                        return
                    }
                    AuthorizationManager.save(authInfo: model!)
                    strongSelf.isRefreshing = false
                    strongSelf.requestsToRetry.forEach { $0(false, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                    SVProgressHUD.dismiss(withDelay: 0.5)
                    completion(false, 0.0) // don't retry
                }
            } else {
                completion(false, 0.0)
            }
        }
        SVProgressHUD.dismiss(withDelay: 0.5)
    }
}
