//
//  HomeViewController.swift
//  Catalyst-Demo
//
//  Created by Bliss on 20/1/21.
//  
//

import UIKit
import SnapKit
import NimbleExtension

// sourcery: AutoMockable
protocol HomeViewInput: AnyObject, RefreshableViewInput {

    func configure()
    func updateViewModels(_ viewModels: [HomeTableViewCell.ViewModel])
}

// sourcery: AutoMockable
protocol HomeViewOutput: AnyObject {

    func viewDidLoad()
    func didRefresh()
    func didSelect(id: String)
}

final class HomeViewController: UIViewController {

    private let tableView = UITableView()

    private var viewModels = [HomeTableViewCell.ViewModel]()

    let refreshControl = AnimatableRefreshControl()

    var output: HomeViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
}

// MARK: - HomeViewInput

extension HomeViewController: HomeViewInput {

    var refreshingScrollView: UIScrollView { tableView }

    func configure() {
        setUpLayout()
        setUpViews()
    }

    func updateViewModels(_ viewModels: [HomeTableViewCell.ViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
}

// MARK: - Private

extension HomeViewController {

    private func setUpLayout() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setUpViews() {
        setUpTableView()
    }

    private func setUpTableView() {
        tableView.register(HomeTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        setUpRefreshControl(with: #selector(self.refresh(_:)))
    }

    @objc func refresh(_ sender: AnyObject) {
        output?.didRefresh()
    }
}

// MARK: - UITableView

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(HomeTableViewCell.self)
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        output?.didSelect(id: viewModels[indexPath.row].country)
    }
}
