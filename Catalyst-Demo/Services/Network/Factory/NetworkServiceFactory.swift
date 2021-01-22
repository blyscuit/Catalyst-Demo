//
//  NetworkServiceFactory.swift
//  DeeMoney
//
//  Created by Edgars Simanovskis on 14/04/2020.
//  Copyright © 2020 nimble. All rights reserved.
//

import Foundation

final class NetworkServiceFactory {
    
    static let shared = NetworkServiceFactory()

    var api: API!
    
    func setUp(baseURL: String) {

        let api = DemoAPI(baseURL: baseURL, parser: DecoderFactory.defaultJsonDecoder())
        self.api = api
    }

    func createDataService() -> DataServiceProtocol {
        return DataService(api: api)
    }
}
