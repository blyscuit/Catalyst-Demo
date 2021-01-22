//
//  DetailViewController.swift
//  Catalyst-Demo
//
//  Created by Bliss on 20/1/21.
//  
//

import UIKit

// sourcery: AutoMockable
protocol DetailViewInput: AnyObject {

    func configure()
    func setDetail(title: String)
}

// sourcery: AutoMockable
protocol DetailViewOutput: AnyObject {

    func viewDidLoad()
}

final class DetailViewController: UIViewController {

    var output: DetailViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
}

// MARK: - DetailViewInput

extension DetailViewController: DetailViewInput {

    func configure() {
        setUpLayout()
        setUpViews()
    }

    func setDetail(title: String) {
        self.title = title
    }
}

// MARK: - Private

extension DetailViewController {

    private func setUpLayout() {
    }

    private func setUpViews() {
        view.backgroundColor = .white
    }
}
