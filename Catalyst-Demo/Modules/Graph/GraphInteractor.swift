//
//  GraphInteractor.swift
//  Catalyst-Demo
//
//  Created by Bliss on 12/2/21.
//  
//

// sourcery: AutoMockable
protocol GraphInteractorInput: AnyObject {

    func fetchGraph(country: String)
}

// sourcery: AutoMockable
protocol GraphInteractorOutput: AnyObject {

    func didGetGraph(_ data: [TimeSerieModel])
    func didFailedToGetGraph(error: Error)
}

final class GraphInteractor {

    private let dataService: DataServiceProtocol

    private var dataServiceRequest: Request? {
        didSet { oldValue?.cancel() }
    }

    weak var output: GraphInteractorOutput?

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }

    deinit {
        dataServiceRequest?.cancel()
    }
}

// MARK: - GraphInteractorInput

extension GraphInteractor: GraphInteractorInput {

    func fetchGraph(country: String) {
        dataServiceRequest = dataService.fetchGraph(country: country) { [weak output] in
            switch $0 {
            case .success(let model):
                output?.didGetGraph(model)
            case .failure(let error):
                output?.didFailedToGetGraph(error: error)
            }
        }
    }
}
