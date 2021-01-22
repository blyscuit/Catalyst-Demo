//
//  RefreshableViewInput.swift
//  DeeMoney
//
//  Created by Nutan Niraula on 17/12/20.
//  Copyright © 2020 Nimble. All rights reserved.
//

import UIKit

protocol RefreshableViewProtocol {
    
    func startRefreshing()
    func stopRefreshing()
}

protocol RefreshableViewInput: RefreshableViewProtocol {

    var refreshControl: AnimatableRefreshControl { get }
    var refreshingScrollView: UIScrollView { get }

    func setUpRefreshControl(with selector: Selector)
}

extension RefreshableViewInput where Self: UIViewController {

    func setUpRefreshControl(with selector: Selector) {
        refreshControl.addTarget(self, action: selector, for: .valueChanged)
        refreshingScrollView.refreshControl = refreshControl
    }

    func startRefreshing() {
        refreshControl.beginRefreshing()
    }

    func stopRefreshing() {
        refreshControl.endRefreshing()
    }
}
