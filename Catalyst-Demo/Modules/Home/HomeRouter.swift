//
//  HomeRouter.swift
//  Catalyst-Demo
//
//  Created by Bliss on 20/1/21.
//  
//

import UIKit

// sourcery: AutoMockable
protocol HomeRouterInput: AnyObject {

    func showDetail(id: String)
}

final class HomeRouter {

    weak var view: HomeViewInput?

    private var viewController: UIViewController? {
        view as? UIViewController
    }
}

// MARK: - HomeRouterInput

extension HomeRouter: HomeRouterInput {

    func showDetail(id: String) {
        let module = DetailModule()
        module.input.setID(id)
        viewController?.navigationController?.pushViewController(module.view, animated: true)
    }
}
