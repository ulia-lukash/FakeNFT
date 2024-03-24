//
//  NftCollectionCell.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 04.03.2024.
//

import UIKit
import Kingfisher

protocol NftCollectionCellDelegate: AnyObject {
   func didTapLikeFor(nft id: String)
   func didTapCartFor(nft id: String)
   func reloadTable()
}
final class NftCollectionCell: UICollectionViewCell, ReuseIdentifying {

   // MARK: Public Properties

   var viewModel: CollectionViewModelProtocol?
   weak var delegate: NftCollectionCellDelegate?

   // MARK: Private Properties

   private var isLiked: Bool = false
   private var isInCart: Bool = false
   private var nftId: String?

   private lazy var imageView: UIImageView = {
       let imageView = UIImageView()
       imageView.layer.masksToBounds = true
       imageView.layer.cornerRadius = 12
       return imageView
   }()

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
       label.font = .SF17bold
       label.textColor = Asset.Colors.black.color
       label.textAlignment = .left
       return label
   }()

   private lazy var priceLabel: UILabel = {
       let label = UILabel()
       label.font = .SF10medium
       label.textColor = Asset.Colors.black.color
       label.textAlignment = .left
       return label
   }()

   private lazy var cartButton: UIButton = {
       let button = UIButton()
       button.setImage(UIImage(named: "tabler_trash"), for: .normal)
       button.tintColor = Asset.Colors.black.color
       button.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
       return button
   }()

   // MARK: Initializers

   override init(frame: CGRect) {
       super.init(frame: frame)
//        viewModel = CollectionViewModel()
       configCellLayout()
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

   // MARK: Public Methods

   func configure(nft: Nft, isLiked: Bool, isInCart: Bool) {
       priceLabel.text = "\(nft.price) ETH"
       nameLabel.text = nft.name
       ratingView.setRating(with: nft.rating)

       if let urlString = nft.images.randomElement(), let url = URL(string: urlString) {
           let processor = ResizingImageProcessor(
               referenceSize: CGSize(width: contentView.frame.width, height: contentView.frame.width),
               mode: .aspectFill
           )
           |> CroppingImageProcessor(
               size: CGSize(width: contentView.frame.width, height: contentView.frame.width)
           )
           imageView.kf.indicatorType = .activity
           imageView.kf.setImage(
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
       self.isLiked = isLiked
       self.isInCart = isInCart
       self.nftId = nft.id
       likeButton.tintColor = isLiked ? Asset.Colors.red.color : Asset.Colors.whiteUniversal.color
       cartButton.setImage(UIImage(named: isInCart ? "tabler_trash-x" : "tabler_trash"), for: .normal)
   }

   // MARK: Private Methods

   private func configCellLayout() {

       imageView.tintColor = Asset.Colors.red.color
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

   // MARK: @objc Methods

   @objc private func didTapLikeButton() {
       isLiked.toggle()
       likeButton.tintColor = isLiked ? Asset.Colors.red.color : Asset.Colors.whiteUniversal.color
       guard let id = self.nftId else { return }
       delegate?.didTapLikeFor(nft: id)
   }

   @objc private func addToCart() {
       isInCart.toggle()
       cartButton.setImage(UIImage(named: isInCart ? "tabler_trash-x" : "tabler_trash"), for: .normal)
       guard let id = self.nftId else { return }
       delegate?.didTapCartFor(nft: id)
   }

}
