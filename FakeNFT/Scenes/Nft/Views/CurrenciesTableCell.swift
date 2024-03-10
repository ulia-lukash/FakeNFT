//
//  CurrenciesTableCell.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 04.03.2024.
//

import UIKit
import Kingfisher

final class CurrenciesTableCell: UITableViewCell, ReuseIdentifying {

    lazy private var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .blackUniversal
        imageView.layer.cornerRadius = 5
        return imageView
    }()

    lazy private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    lazy private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "$18.11"
        return label
    }()

    lazy private var diffLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .greenUniversal
        label.text = "0,1 (BTC)"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(forCurrency currency: Currency) {
        nameLabel.text = "\(currency.title) (\(currency.name))"
        setCoverImage(forUrl: currency.image)
    }

    private func setUp() {
        contentView.backgroundColor = .segmentInactive
        [coverImageView, nameLabel, priceLabel, diffLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            coverImageView.widthAnchor.constraint(equalToConstant: 32),
            coverImageView.heightAnchor.constraint(equalToConstant: 32),

            nameLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.heightAnchor.constraint(equalToConstant: 18),

            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 10),
            priceLabel.heightAnchor.constraint(equalToConstant: 20),

            diffLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            diffLabel.heightAnchor.constraint(equalToConstant: 18),
            diffLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func setCoverImage(forUrl url: URL) {
        let processor = ResizingImageProcessor(
            referenceSize: CGSize(width: 32, height: 32),
            mode: .aspectFill
        )
        |> CroppingImageProcessor(size: CGSize(width: 32, height: 32))
        coverImageView.kf.indicatorType = .activity
        coverImageView.kf.setImage(
            with: url,
            options: [
                .processor(processor)
            ]) { result in
                switch result {
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                default:
                    break
                }
            }
    }
}
