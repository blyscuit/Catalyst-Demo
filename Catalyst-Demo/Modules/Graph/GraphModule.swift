//
//  GraphModule.swift
//  Catalyst-Demo
//
//  Created by Bliss on 12/2/21.
//  
//

// sourcery: AutoMockable
protocol GraphInput: AnyObject {
}

// sourcery: AutoMockable
protocol GraphOutput: AnyObject {
}

final class GraphModule {

    let view: GraphViewController
    let presenter: GraphPresenter
    let router: GraphRouter
    let interactor: GraphInteractor

    var output: GraphOutput? {
        get { presenter.output }
        set { presenter.output = newValue }
    }

    var input: GraphInput { presenter }

    init(country: String) {
        view = GraphViewController()
        router = GraphRouter()
        interactor = GraphInteractor(dataService: NetworkServiceFactory.shared.createDataService())
        presenter = GraphPresenter(
            router: router,
            interactor: interactor,
            country: country
        )

        view.output = presenter

        presenter.view = view

        interactor.output = presenter

        router.view = view
    }
}
