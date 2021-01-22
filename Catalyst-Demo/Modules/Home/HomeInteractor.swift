//
//  HomeInteractor.swift
//  Catalyst-Demo
//
//  Created by Bliss on 20/1/21.
//  
//

// sourcery: AutoMockable
protocol HomeInteractorInput: AnyObject {

    func fetchData()
}

// sourcery: AutoMockable
protocol HomeInteractorOutput: AnyObject {

    func didGetData(_ data: SummaryModel)
    func didFailedToGetData(error: Error)
}

final class HomeInteractor {

    private let dataService: DataServiceProtocol

    private var dataServiceRequest: Request? {
        didSet { oldValue?.cancel() }
    }

    weak var output: HomeInteractorOutput?

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }

    deinit {
        dataServiceRequest?.cancel()
    }
}

// MARK: - HomeInteractorInput

extension HomeInteractor: HomeInteractorInput {

    func fetchData() {
        dataServiceRequest = dataService.fetchData { [weak output] in
            switch $0 {
            case .success(let model):
                output?.didGetData(model)
            case .failure(let error):
                output?.didFailedToGetData(error: error)
            }
        }
    }
}
