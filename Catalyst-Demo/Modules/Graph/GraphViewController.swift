//
//  GraphViewController.swift
//  Catalyst-Demo
//
//  Created by Bliss on 12/2/21.
//  
//

import UIKit
import SwiftUICharts
import SwiftUI

// sourcery: AutoMockable
protocol GraphViewInput: AnyObject {

    func configure()
    func populate(data: [Double])
}

// sourcery: AutoMockable
protocol GraphViewOutput: AnyObject {

    func viewDidLoad()
}

final class GraphViewController: UIViewController {

    var output: GraphViewOutput?

    private var contentView = UIHostingController(rootView: LineView(data: []))
    private let embedView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        #if targetEnvironment(macCatalyst)
        navigationController?.navigationBar.isHidden = false
        #endif
    }

    override func viewWillDisappear(_ animated: Bool) {
        #if targetEnvironment(macCatalyst)
        navigationController?.navigationBar.isHidden = true
        #endif
    }
}

// MARK: - GraphViewInput

extension GraphViewController: GraphViewInput {

    func configure() {
        view.addSubview(embedView)

        embedView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview()
        }
    }

    func populate(data: [Double]) {
        let lineView = LineView(data: data, title: "Line chart", legend: "Full screen")
        lineView.style.gradientColor = GradientColors.orange
        lineView.style.backgroundColor = Color(self.view.backgroundColor ?? .systemBackground)
        contentView = UIHostingController(
            rootView: lineView
        )
        embedView.addSubview(contentView.view)
        contentView.view.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
