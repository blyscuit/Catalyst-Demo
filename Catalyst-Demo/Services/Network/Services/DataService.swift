//
//  DataService.swift
//  Catalyst
//
//  Created by Nutan Niraula on 22/10/20.
//

// sourcery: AutoMockable
protocol DataServiceProtocol {

    func fetchData(
        completion: @escaping RequestCompletion<SummaryModel>
    ) -> Request?
}

final class DataService: NetworkService, DataServiceProtocol {

    func fetchData(
        completion: @escaping RequestCompletion<SummaryModel>
    ) -> Request? {
        let configuration = RequestConfiguration(
            method: .get,
            url: url(forEndpoint: "summary")
        )
        return api.performRequest(with: configuration, completion: dataParsedCompletion(completion))
    }
}
