//
//  CatalogTableFooterView.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 11.02.2024.
//

import UIKit

final class CatalogTableFooterView: UITableViewHeaderFooterView, ReuseIdentifying {

    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.font = .SF17bold
        label.textColor = Asset.Colors.black.color
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureFooter()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(labelText: String) {
        footerLabel.text = labelText
    }

    private func configureFooter() {
        addSubview(footerLabel)
        NSLayoutConstraint.activate([
            footerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            footerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            footerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
