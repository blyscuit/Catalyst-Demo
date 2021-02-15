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

    private var dropInteraction: UIDropInteraction?

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        #if targetEnvironment(macCatalyst)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        #endif
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
        view.backgroundColor = .systemBackground

        graphButton.setTitle("Graph", for: .normal)
        graphButton.addTarget(self, action: #selector(didTapGraphButton), for: .touchUpInside)
        graphButton.setTitleColor(titleLabel.textColor, for: .normal)
        if #available(macCatalyst 13.4, *) {
            graphButton.isPointerInteractionEnabled = true
        } else if #available(iOS 13.4, *) {
            graphButton.isPointerInteractionEnabled = true
        }
       #if targetEnvironment(macCatalyst)
        navigationController?.navigationBar.isHidden = true
        #endif

        dropInteraction = UIDropInteraction(delegate: self)
        view.interactions.append(dropInteraction!)
    }

    @objc func didTapGraphButton() {
        output?.didTapGraph()
    }
}

// MARK: - UIDropInteractionDelegate

extension DetailViewController: UIDropInteractionDelegate {

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        session.canLoadObjects(ofClass: String.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        UIDropProposal(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: String.self) {
          [weak self] string in
            (self?.output as? DetailInput)?.setID(string.first ?? "")
        }
    }
}
