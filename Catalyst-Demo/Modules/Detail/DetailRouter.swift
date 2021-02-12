//
//  DetailRouter.swift
//  Catalyst-Demo
//
//  Created by Bliss on 20/1/21.
//  
//

import UIKit

// sourcery: AutoMockable
protocol DetailRouterInput: AnyObject {

    func showGraph(country: String)
}

final class DetailRouter {

    weak var view: DetailViewInput?

    private var viewController: UIViewController? {
        view as? UIViewController
    }
}

// MARK: - DetailRouterInput

extension DetailRouter: DetailRouterInput {

    func showGraph(country: String) {
        let module = GraphModule(country: country)
        viewController?.navigationController?.pushViewController(module.view, animated: true)
    }
}
