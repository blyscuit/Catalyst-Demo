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
protocol HomeViewInput: AnyObject, RefreshableViewInput, SplitViewPrimaryView {

    func configure()
    func updateViewModels(_ viewModels: [HomeTableViewCell.ViewModel])
}

// sourcery: AutoMockable
protocol HomeViewOutput: AnyObject {

    func viewDidLoad()
    func didRefresh()
    func didSelect(id: String)
    func didSearch(text: String?)
}

final class HomeViewController: UIViewController {

    private let tableView = UITableView()

    private var viewModels = [HomeTableViewCell.ViewModel]()

    let refreshControl = AnimatableRefreshControl()

    var output: HomeViewOutput?
    var isPresenting: Bool = true
    var resultSearchController = UISearchController()

    override var canBecomeFirstResponder: Bool { true }
    override var keyCommands: [UIKeyCommand]? {
        let refreshKeyCommand
          = UIKeyCommand(input: "R",
                         modifierFlags: .command,
                         action: #selector(refresh(_:)))
        refreshKeyCommand.discoverabilityTitle = "Refresh"
        let searchCommand
          = UIKeyCommand(input: "F",
                         modifierFlags: .command,
                         action: #selector(beginSearch))
        searchCommand.discoverabilityTitle = "Search"
        let upKeyCommand
          = UIKeyCommand(input: "[",
                         modifierFlags: [.command],
                         action: #selector(goToPrevious))
        upKeyCommand.discoverabilityTitle = "Previous Entry"
        let downKeyCommand
          = UIKeyCommand(input: "]",
                         modifierFlags: [.command],
                         action: #selector(goToNext))
        downKeyCommand.discoverabilityTitle = "Next Entry"
        return [refreshKeyCommand, searchCommand, upKeyCommand, downKeyCommand]
    }
    override func pressesBegan(_ presses: Set<UIPress>,
                               with event: UIPressesEvent?) {
      for press in presses {
        guard let key = press.key else { continue }
        switch key.keyCode {
        case .keyboardUpArrow,
             .keyboardLeftArrow:
            goToPrevious()
        case .keyboardDownArrow,
             .keyboardRightArrow:
            goToNext()
        default:
          super.pressesBegan(presses, with: event)
        }
      }
    }

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
            $0.top.equalTo(view.snp.topMargin)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setUpViews() {
        setUpTableView()

        setUpSearchViewController()

        #if targetEnvironment(macCatalyst)
        navigationController?.navigationBar.isHidden = true
        #endif
        // needs this for UISearchController to hide when push
        self.definesPresentationContext = true
        title = "List"
    }

    private func setUpTableView() {
        tableView.register(HomeTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelection = false
        setUpRefreshControl(with: #selector(self.refresh(_:)))
    }

    private func setUpSearchViewController() {
        // has bug in Catalyst
        // https://stackoverflow.com/questions/58468235/uisearchcontroller-uisearchbar-behaves-differently-under-macos-than-ios
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()

            tableView.tableHeaderView = controller.searchBar

            return controller
        })()
    }

    @objc func refresh(_ sender: AnyObject) {
        output?.didRefresh()
    }

    @objc func goToPrevious() {
        guard let index = tableView.indexPathForSelectedRow?.row,
              index > 0 else { return }
        let previousIndex = index - 1
        let indexPath = IndexPath(row: previousIndex,
                                  section: 0)
        tableView.selectRow(at: indexPath,
                            animated: false,
                            scrollPosition: .middle)
        output?.didSelect(id: viewModels[indexPath.row].country)
    }

    @objc func goToNext() {
        guard let index = tableView.indexPathForSelectedRow?.row,
              index < viewModels.count - 1 else { return }
        let nextIndex = index + 1
        let indexPath = IndexPath(row: nextIndex,
                                  section: 0)
        tableView.selectRow(at: indexPath,
                            animated: false,
                            scrollPosition: .middle)
        output?.didSelect(id: viewModels[indexPath.row].country)
    }

    @objc func beginSearch() {
        resultSearchController.searchBar.becomeFirstResponder()
    }
}

// MARK: - UISearchResultsUpdating

extension HomeViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        output?.didSearch(text: searchText)
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
        let contextInteraction
            = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(contextInteraction)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        output?.didSelect(id: viewModels[indexPath.row].country)
    }
}

// MARK: - UIContextMenuInteractionDelegate

extension HomeViewController: UIContextMenuInteractionDelegate {

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {

        //1
        let locationInTableView =
            interaction.location(in: tableView)
        //2
        guard let indexPath = tableView
                .indexPathForRow(at: locationInTableView)
        else { return nil }
        //3
        //        let entry = DataService.shared.allEntries[indexPath.row]
        //4
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { _ -> UIMenu? in

            //5
            var rootChildren: [UIMenuElement] = []
            //6
            let noOpAction = self.createNoOpAction()
            //7
            rootChildren.append(noOpAction)
            rootChildren.append(self.addOpenNewWindowAction())
            //8
            let menu = UIMenu(title: "", image: nil,
                              identifier: nil, options: [],
                              children: rootChildren)
            return menu
        }
    }

    //1
    func createNoOpAction() -> UIAction {
        let noOpAction = UIAction(title: "Do Nothing",image: nil,
                                  identifier: nil, discoverabilityTitle: nil,attributes: [],
                                  state: .off) { _ in
            // Do nothing
        }
        return noOpAction
    }

    func addOpenNewWindowAction() -> UIAction {
        //1
        let openInNewWindowAction = UIAction(
            title: "Open in New Window",
            image: UIImage(systemName: "uiwindow.split.2x1"),
            identifier: nil,
            discoverabilityTitle: nil,
            attributes: [],
            state: .off) { _ in
            //2
            self.createNewWindow() }
        return openInNewWindowAction
    }

    func createNewWindow() {
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: nil, options: nil, errorHandler: nil)
    }
}
