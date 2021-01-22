//
//  NetworkService.swift
//
//  Created by Edgars Simanovskis on 14/04/2020.
//  Copyright © 2020 nimble. All rights reserved.
//

import Foundation

class NetworkService {

    let api: API
    private let decoder: JSONDecoder

    init(api: API, decoder: JSONDecoder = DecoderFactory.defaultJsonDecoder()) {
        self.api = api
        self.decoder = decoder
    }

    func url(forEndpoint endpoint: String) -> String {
        api.url(forEndpoint: endpoint)
    }

    func url(forEndpoint endpoint: String, baseURL: String) -> String {
        api.url(forEndpoint: endpoint, baseURL: baseURL)
    }

    func dataParsedCompletion<Response: Decodable>(
        _ completion: @escaping RequestCompletion<Response>
    ) -> RequestCompletion<Data> {
        return { result in
            switch result {
            case .success(let data):
                do {
                    let model = try self.decoder.decode(Response.self, from: data)
                    completion(.success(model))
                } catch {
                    print("Unable to parse")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
