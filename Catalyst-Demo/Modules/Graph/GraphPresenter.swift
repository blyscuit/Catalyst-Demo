//
//  GraphPresenter.swift
//  Catalyst-Demo
//
//  Created by Bliss on 12/2/21.
//  
//

final class GraphPresenter {

    let router: GraphRouterInput
    let interactor: GraphInteractorInput

    weak var view: GraphViewInput?
    weak var output: GraphOutput?

    private let country: String

    init(
        router: GraphRouterInput,
        interactor: GraphInteractorInput,
        country: String
    ) {
        self.router = router
        self.interactor = interactor
        self.country = country
    }
}

// MARK: - GraphViewOutput

extension GraphPresenter: GraphViewOutput {

    func viewDidLoad() {
        view?.configure()
        interactor.fetchGraph(country: country)
    }
}

// MARK: - GraphInteractorOutput

extension GraphPresenter: GraphInteractorOutput {

    func didGetGraph(_ data: [TimeSerieModel]) {
        view?.populate(data: data.map { Double($0.confirmed) } )
    }

    func didFailedToGetGraph(error: Error) {
        
    }
}

// MARK: - GraphInput

extension GraphPresenter: GraphInput {
}
