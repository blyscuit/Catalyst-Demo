//
//  PrimarySplitViewController.swift
//  Catalyst-Demo
//
//  Created by Bliss on 22/1/21.
//

import UIKit

class PrimarySplitViewController: UISplitViewController,
                                  UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        preferredDisplayMode = .oneBesideSecondary
        primaryBackgroundStyle = .sidebar
    }

    func splitViewController(
             _ splitViewController: UISplitViewController,
             collapseSecondary secondaryViewController: UIViewController,
             onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return ((primaryViewController as? UINavigationController)?.topViewController as? SplitViewPrimaryView)?.isPresenting ?? false
    }
}
