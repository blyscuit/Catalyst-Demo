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
    func fetchGraph(
        country: String,
        completion: @escaping RequestCompletion<[TimeSerieModel]>
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

    func fetchGraph(
        country: String, completion: @escaping RequestCompletion<[TimeSerieModel]>) -> Request? {
        let configuration = RequestConfiguration(
            method: .get,
            url: url(forEndpoint: "live/country/\(country)")
        )
        return api.performRequest(with: configuration, completion: dataParsedCompletion(completion))
    }
}
