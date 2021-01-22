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
}

final class DetailRouter {

    weak var view: DetailViewInput?

    private var viewController: UIViewController? {
        view as? UIViewController
    }
}

// MARK: - DetailRouterInput

extension DetailRouter: DetailRouterInput {
}
