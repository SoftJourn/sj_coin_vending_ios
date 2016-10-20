//
//  OAuth2Handler.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/27/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation
import Alamofire

class OAuth2Handler: RequestRetrier {
    
    fileprivate typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
    
    // MARK: Constants
    static let shared = OAuth2Handler()
    
    fileprivate var isRefreshing = false
    fileprivate var requestsToRetry: [RequestRetryCompletion] = []
    fileprivate let lock = NSLock()
    fileprivate var accessToken: String {
        
        return AuthorizationManager.getToken()
    }
    fileprivate var refreshToken: String {
        
        return AuthorizationManager.getRefreshToken()
    }
    
    // MARK: - RequestRetrier
//    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
//        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
//            
//            refreshTokens { success, token, refresh in
//                if success {
//                    AuthorizationManager.update(authInfo: token!, refresh: refresh!)
//                    completion(false, 0.0) // don't retry
//                }
//            }
//            //completion(true, 1.0) // retry after 1 second
//        } else {
//            completion(false, 0.0) // don't retry
//        }
//    }
    
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] success, token, refresh in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    if success {
                        AuthorizationManager.update(authInfo: token!, refresh: refresh!)
                        completion(false, 0.0) // don't retry
                    }
                    strongSelf.requestsToRetry.forEach { $0(success, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            } else {
                completion(false, 0.0)
            }
        }
    }
    
    // MARK: - Private - Refresh Tokens
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        
        guard !isRefreshing else { return }
        isRefreshing = true
        
        AuthorizationManager.refreshRequest { [unowned self] model, error in
            guard let token = model?.accessToken, let refresh = model?.refreshToken else {
                print("refresh token failed")
                return completion(false, nil, nil)
            }
            completion(true, token, refresh)
            self.isRefreshing = false
        }
    }
}
