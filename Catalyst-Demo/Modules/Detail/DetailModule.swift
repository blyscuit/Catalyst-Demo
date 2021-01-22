//
//  DetailModule.swift
//  Catalyst-Demo
//
//  Created by Bliss on 20/1/21.
//  
//

// sourcery: AutoMockable
protocol DetailInput: AnyObject {
    
    func setID(_ id: String)
}

// sourcery: AutoMockable
protocol DetailOutput: AnyObject {
}

final class DetailModule {

    let view: DetailViewController
    let presenter: DetailPresenter
    let router: DetailRouter
    let interactor: DetailInteractor

    var output: DetailOutput? {
        get { presenter.output }
        set { presenter.output = newValue }
    }

    var input: DetailInput { presenter }

    init() {
        view = DetailViewController()
        router = DetailRouter()
        interactor = DetailInteractor()
        presenter = DetailPresenter(
            router: router,
            interactor: interactor
        )

        view.output = presenter

        presenter.view = view

        interactor.output = presenter

        router.view = view
    }
}
