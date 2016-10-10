//
//  StringDecorator.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/26/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Alamofire

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}
