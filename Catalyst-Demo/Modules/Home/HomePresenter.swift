//
//  HomePresenter.swift
//  Catalyst-Demo
//
//  Created by Bliss on 20/1/21.
//  
//

final class HomePresenter {

    let router: HomeRouterInput
    let interactor: HomeInteractorInput

    weak var view: HomeViewInput?
    weak var output: HomeOutput?

    init(
        router: HomeRouterInput,
        interactor: HomeInteractorInput
    ) {
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - HomeViewOutput

extension HomePresenter: HomeViewOutput {

    func viewDidLoad() {
        view?.configure()
        didRefresh()
    }

    func didRefresh() {
        view?.startRefreshing()
        interactor.fetchData()
    }

    func didSelect(id: String) {
        router.showDetail(id: id)
    }
}

// MARK: - HomeInteractorOutput

extension HomePresenter: HomeInteractorOutput {

    func didGetData(_ data: SummaryModel) {
        view?.stopRefreshing()
        view?.updateViewModels(
            data.countries.map {
                HomeTableViewCell.ViewModel(
                    country: $0.country,
                    newConfirmed: "\($0.newConfirmed)",
                    totalConfirmed: "\($0.totalConfirmed)"
                )
            }
        )
    }

    func didFailedToGetData(error: Error) {
        view?.stopRefreshing()
    }
}

// MARK: - HomeInput

extension HomePresenter: HomeInput {
}
