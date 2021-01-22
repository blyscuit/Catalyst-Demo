//  swiftlint:disable:this file_name
//  Network+Typealias.swift
//  DeeMoney
//
//  Created by Nutan Niraula on 14/10/20.
//

import Alamofire

typealias HTTPMethod = Alamofire.HTTPMethod
typealias URLConvertible = Alamofire.URLConvertible
typealias Headers = [String: String]
typealias Parameters = [String: Any]
typealias ParameterEncoding = Alamofire.ParameterEncoding
typealias URLEncoding = Alamofire.URLEncoding
typealias JSONEncoding = Alamofire.JSONEncoding
typealias RequestAdapterProtocol = Alamofire.RequestAdapter
typealias RequestRetrierProtocol = Alamofire.RequestRetrier
typealias RequestCompletion<T> = (Result<T, Error>) -> Void
typealias EmptyResultCompletion = RequestCompletion<EmptyAPIResponse>
typealias CompletionHandler = () -> Void
