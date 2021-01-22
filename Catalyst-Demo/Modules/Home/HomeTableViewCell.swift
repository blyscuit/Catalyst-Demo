//
//  HomeTableViewCell.swift
//  Catalyst-Demo
//
//  Created by Bliss on 20/1/21.
//

import UIKit

final class HomeTableViewCell: UITableViewCell {

    struct ViewModel {
        let country, newConfirmed, totalConfirmed: String
    }

    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    private let lineView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayouts()
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

extension HomeTableViewCell {

    private func setUpLayouts() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(lineView)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.bottom.lessThanOrEqualToSuperview().offset(-12.0)
            $0.leading.equalToSuperview().inset(22.0)
            $0.width.equalToSuperview().multipliedBy(0.3)
        }

        infoLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8.0)
            $0.trailing.equalToSuperview().inset(22.0)
            $0.bottom.lessThanOrEqualToSuperview().offset(-12.0)
            $0.firstBaseline.equalTo(titleLabel)
        }

        lineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalTo(infoLabel)
        }

        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    private func setUpViews() {
        infoLabel.textAlignment = .right
    }
}

// MARK: - Public

extension HomeTableViewCell {

    func configure(
        with model: ViewModel
    ) {
        titleLabel.text = model.country
        infoLabel.text = model.totalConfirmed
    }
}

