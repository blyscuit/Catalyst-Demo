//
//  DetailPresenter.swift
//  Catalyst-Demo
//
//  Created by Bliss on 20/1/21.
//  
//

final class DetailPresenter {

    let router: DetailRouterInput
    let interactor: DetailInteractorInput

    weak var view: DetailViewInput?
    weak var output: DetailOutput?

    init(
        router: DetailRouterInput,
        interactor: DetailInteractorInput
    ) {
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - DetailViewOutput

extension DetailPresenter: DetailViewOutput {

    func viewDidLoad() {
        view?.configure()
    }
}

// MARK: - DetailInteractorOutput

extension DetailPresenter: DetailInteractorOutput {
}

// MARK: - DetailInput

extension DetailPresenter: DetailInput {

    func setID(_ id: String) {
        view?.setDetail(title: id)
    }
}
