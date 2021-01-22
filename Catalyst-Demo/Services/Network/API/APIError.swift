//
//  APIError.swift
//  Catalyst-Demo
//
//  Created by Nutan Niraula on 15/10/20.
//

import Foundation

enum APIError: Error {
    case genericError
    case apiError(detail: String)
}

extension APIError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .genericError:
            return "API Error"
        case .apiError(let detail):
            return detail
        }
    }
}
