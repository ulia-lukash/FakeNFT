//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 11.02.2024.
//

import Foundation
import UIKit
import Kingfisher

final class CatalogTableViewCell: UITableViewCell, ReuseIdentifying {

    private lazy var cover: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureCellLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(for name: String) {

        let urlString = "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/" + name + ".png"
        let url = URL(string: urlString)!

        let processor = ResizingImageProcessor(referenceSize: CGSize(width: contentView.frame.width, height: 140), mode: .aspectFill)
        |> CroppingImageProcessor(size: CGSize(width: contentView.frame.width, height: 140))
        |> RoundCornerImageProcessor(cornerRadius: 12)
        cover.kf.indicatorType = .activity
        cover.kf.setImage(
            with: url,
            options: [
                .processor(processor)
            ]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }

    }
    // MARK: - Private Methods

    private func configureCellLayout() {

        contentView.addSubview(cover)

        NSLayoutConstraint.activate([
            cover.topAnchor.constraint(equalTo: contentView.topAnchor),
            cover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cover.heightAnchor.constraint(equalToConstant: 140),
            contentView.heightAnchor.constraint(equalToConstant: 145)
        ])
    }
}
