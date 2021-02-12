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

    var selectedDetail: String { get }

    func configure()
    func setDetail(title: String)
}

// sourcery: AutoMockable
protocol DetailViewOutput: AnyObject {

    func viewDidLoad()
    func didTapGraph()
}

final class DetailViewController: UIViewController {

    var output: DetailViewOutput?

    private let titleLabel = UILabel()
    private let graphButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
}

// MARK: - DetailViewInput

extension DetailViewController: DetailViewInput {

    var selectedDetail: String { self.title ?? "" }

    func configure() {
        setUpLayout()
        setUpViews()
    }

    func setDetail(title: String) {
        self.title = title
        titleLabel.text = title
    }
}

// MARK: - Private

extension DetailViewController {

    private func setUpLayout() {
        view.addSubview(titleLabel)
        view.addSubview(graphButton)

        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(view.snp.topMargin).inset(20.0)
        }

        graphButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20.0)
        }
    }

    private func setUpViews() {

        graphButton.setTitle("Graph", for: .normal)
        graphButton.addTarget(self, action: #selector(didTapGraphButton), for: .touchUpInside)

        #if targetEnvironment(macCatalyst)
        navigationController?.navigationBar.isHidden = true
        #endif
    }

    @objc func didTapGraphButton() {
        output?.didTapGraph()
    }
}
