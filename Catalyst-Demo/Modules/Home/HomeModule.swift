//
//  HomeModule.swift
//  Catalyst-Demo
//
//  Created by Bliss on 20/1/21.
//  
//

// sourcery: AutoMockable
protocol HomeInput: AnyObject {
}

// sourcery: AutoMockable
protocol HomeOutput: AnyObject {
}

final class HomeModule {

    let view: HomeViewController
    let presenter: HomePresenter
    let router: HomeRouter
    let interactor: HomeInteractor

    var output: HomeOutput? {
        get { presenter.output }
        set { presenter.output = newValue }
    }

    var input: HomeInput { presenter }

    init() {
        view = HomeViewController()
        router = HomeRouter()
        interactor = HomeInteractor(dataService: NetworkServiceFactory.shared.createDataService())
        presenter = HomePresenter(
            router: router,
            interactor: interactor
        )

        view.output = presenter

        presenter.view = view

        interactor.output = presenter

        router.view = view
    }
}
