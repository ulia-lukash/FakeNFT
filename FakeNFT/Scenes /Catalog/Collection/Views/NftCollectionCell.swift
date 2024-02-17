//
//  NftCollectionCell.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 13.02.2024.
//

import Foundation
import UIKit
import Kingfisher

final class NftCollectionCell: UICollectionViewCell, ReuseIdentifying {

    let image1 = "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/1.png"
    let image2 = "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/2.png"
    let image3 = "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/3.png"
    private var mockNft: Nft?
    private var isLiked: Bool = false
    private var isInCart: Bool = false
    private lazy var imageView = UIImageView()

    private lazy var likeButton: UIButton = {
        let button = UIButton()

        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()

    private lazy var ratingView = StarRatingView()
    private lazy var labelView = UIView()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.segmentActive
        label.textAlignment = .left
        return label
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor.segmentActive
        label.textAlignment = .left
        return label
    }()
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "tabler_trash"), for: .normal)
        button.tintColor = UIColor.segmentActive
        button.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configCellLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configCellLayout() {

        [imageView, cartButton, ratingView, labelView, likeButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [nameLabel, priceLabel].forEach {
            labelView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            ratingView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            labelView.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 4),
            labelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            labelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            labelView.heightAnchor.constraint(equalToConstant: 40),
            nameLabel.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 1),
            nameLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            nameLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 12),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.leadingAnchor.constraint(equalTo: labelView.trailingAnchor),
            cartButton.centerYAnchor.constraint(equalTo: labelView.centerYAnchor)

        ])
    }

    private func configure() {
        let images = [image1, image2, image3]
        mockNft = Nft(createdAt: "2023-04-20T02:22:27Z", name: "Archie", id: "49", images: images, rating: 3, description: "An animated gif of a bear fishing.", price: 7.74, author: "18")
        if let nft = mockNft {

            priceLabel.text = "\(nft.price) ETH"
        }
        nameLabel.text = mockNft?.name

        let urlString = image1
        let url = URL(string: urlString)!

        let processor = ResizingImageProcessor(referenceSize: CGSize(width: contentView.frame.width, height: contentView.frame.width), mode: .aspectFill)
        |> CroppingImageProcessor(size: CGSize(width: contentView.frame.width, height: contentView.frame.width))
        |> RoundCornerImageProcessor(cornerRadius: 12)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
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
        ratingView.setRating(with: mockNft?.rating ?? 0)
        isLiked = false
        isInCart = false
        likeButton.tintColor = isLiked ? UIColor.redUniversal : UIColor.whiteUniversal
        cartButton.setImage(UIImage(named: isInCart ? "tabler_trash-x" : "tabler_trash"), for: .normal)
    }

    @objc private func didTapLikeButton() {
        isLiked = !isLiked
        likeButton.tintColor = isLiked ? UIColor.redUniversal : UIColor.whiteUniversal
    }

    @objc private func addToCart() {
        isInCart = !isInCart
        cartButton.setImage(UIImage(named: isInCart ? "tabler_trash-x" : "tabler_trash"), for: .normal)
    }
}
