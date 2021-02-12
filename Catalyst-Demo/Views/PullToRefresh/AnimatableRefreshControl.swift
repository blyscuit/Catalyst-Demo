//
//  AnimatableRefreshControl.swift
//  DeeMoney
//
//  Created by Nutan Niraula on 17/12/20.
//  Copyright © 2020 Nimble. All rights reserved.
//

import UIKit

/// This Refresh control is capable of resuming animation when view is switched (example: when tab is switched or app resumes from background task
final class AnimatableRefreshControl: UIRefreshControl {

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil && isRefreshing, let scrollView = superview as? UIScrollView else { return }

        let offset = scrollView.contentOffset
        UIView.performWithoutAnimation { endRefreshing() }
        beginRefreshing()
        scrollView.contentOffset = offset
        backgroundColor = .systemBackground
    }
}
