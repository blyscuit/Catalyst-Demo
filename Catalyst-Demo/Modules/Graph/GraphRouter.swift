//
//  GraphRouter.swift
//  Catalyst-Demo
//
//  Created by Bliss on 12/2/21.
//  
//

import UIKit

// sourcery: AutoMockable
protocol GraphRouterInput: AnyObject {
}

final class GraphRouter {

    weak var view: GraphViewInput?

    private var viewController: UIViewController? {
        view as? UIViewController
    }
}

// MARK: - GraphRouterInput

extension GraphRouter: GraphRouterInput {
}
