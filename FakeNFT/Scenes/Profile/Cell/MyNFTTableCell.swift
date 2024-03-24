//
//  MyNFTTableCell.swift
//  FakeNFT
//
//  Created by Григорий Машук on 18.02.24.
//

import Kingfisher
import Cosmos
import UIKit

protocol MyNFTTableCellDelegate: AnyObject {
    func likeTap(_ cell: UITableViewCell)
}

// MARK: MyNFTTableCell
final class MyNFTTableCell: UITableViewCell, ReuseIdentifying {
    private enum ConstMyNFTCell: String {
        case favouritesIcons
    }
    
    weak var delegate: MyNFTTableCellDelegate?
    
    private lazy var nftImageView: UIImageView = {
        let nftImageView = UIImageView()
        nftImageView.layer.cornerRadius = 12
        nftImageView.layer.masksToBounds = true
        return nftImageView
    }()
    
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.isUserInteractionEnabled = true
        let image = UIImage(systemName: "heart.fill")
        likeButton.setImage(image, for: .normal)
        likeButton.addTarget(self, action: #selector(didLike), for: .touchUpInside)
        
        return likeButton
    }()
    
    private lazy var nameStack = UIView()
    
    private lazy var nameNFTLabel: UILabel = {
        let nameNFTLabel = UILabel()
        nameNFTLabel.font = .bodyBold
        nameNFTLabel.textColor = Asset.Colors.black.color
        
        return nameNFTLabel
    }()
    
    private lazy var starRatingView: CosmosView = {
        let starRatingView = CosmosView()
        starRatingView.rating = 0
        starRatingView.settings.starSize = 15
        starRatingView.settings.filledColor = Asset.Colors.yellow.color
        starRatingView.settings.starMargin = 2
        starRatingView.settings.emptyColor = Asset.Colors.lightGray.color
        starRatingView.settings.emptyBorderColor = .clear
        starRatingView.settings.filledBorderColor = .clear
        return starRatingView
    }()
    
    private lazy var nameAuthorLabel: UILabel = {
        let nameAuthorLabel = UILabel()
        nameAuthorLabel.font = .caption2
        nameAuthorLabel.textColor = Asset.Colors.black.color
        nameAuthorLabel.numberOfLines = 0
        nameAuthorLabel.lineBreakMode = .byWordWrapping
        nameAuthorLabel.textAlignment = .left
        
        return nameAuthorLabel
    }()
    
    private lazy var priceStack = UIView()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.text = ConstLocalizable.myNftCellPrice
        priceLabel.textAlignment = .left
        priceLabel.textColor = Asset.Colors.black.color
        priceLabel.font = .caption2
        
        return priceLabel
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let priceValueLabel = UILabel()
        priceValueLabel.textAlignment = .left
        priceValueLabel.textColor = Asset.Colors.black.color
        priceValueLabel.font = .bodyBold
        
        return priceValueLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupUIItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        nftImageView.kf.cancelDownloadTask()
    }
}

extension MyNFTTableCell {
    // MARK: private @objc func
    @objc
    private func didLike() {
        guard let delegate else { return }
        likeButttonPulse(flag: true)
        delegate.likeTap(self)
    }
    
    // MARK: private func
    private func setupUIItem() {
        addSubviews()
        setupConstraint()
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            nameStack.widthAnchor.constraint(equalToConstant: 118),
            nameStack.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nameStack.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),

            nameNFTLabel.heightAnchor.constraint(equalToConstant: 22),
            nameNFTLabel.leadingAnchor.constraint(equalTo: nameStack.leadingAnchor),
            nameNFTLabel.bottomAnchor.constraint(equalTo: starRatingView.topAnchor, constant: -4),
            
            starRatingView.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            starRatingView.leadingAnchor.constraint(equalTo: nameStack.leadingAnchor),
            
            nameAuthorLabel.topAnchor.constraint(equalTo: starRatingView.bottomAnchor, constant: 4),
            nameAuthorLabel.widthAnchor.constraint(equalToConstant: 114),
            nameAuthorLabel.leadingAnchor.constraint(equalTo: nameStack.leadingAnchor),
            
            priceStack.heightAnchor.constraint(equalToConstant: 42),
            priceStack.centerYAnchor.constraint(equalTo: nameStack.centerYAnchor),
            priceStack.leadingAnchor.constraint(equalTo: nameStack.trailingAnchor),
            priceStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            priceLabel.topAnchor.constraint(equalTo: priceStack.topAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: priceStack.leadingAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 18),
            
            priceValueLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            priceValueLabel.heightAnchor.constraint(equalToConstant: 22),
            priceValueLabel.leadingAnchor.constraint(equalTo: priceStack.leadingAnchor)
        ])
    }
    
    private func addSubviews() {
        backgroundColor = .clear
        [nftImageView, likeButton, nameStack,
         nameNFTLabel, priceStack,
         nameAuthorLabel, priceLabel, priceValueLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
        [nftImageView, likeButton, nameStack, priceStack].forEach {
            addSubview($0)
        }
        [nameNFTLabel, starRatingView, nameAuthorLabel].forEach {
            nameStack.addSubview($0)
        }
        [priceLabel, priceValueLabel].forEach {
            priceStack.addSubview($0)
        }
    }
    
    func like(flag: Bool) {
        likeButton.tintColor = flag ? Asset.Colors.red.color : .white
    }
    
    func config(model: MyNFTCellModel) {
        nftImageView.kf.setImage(with: model.urlNFT)
        nameNFTLabel.text = model.nameNFT.components(separatedBy: " ").first
        starRatingView.rating = model.rating >= 5.0 ? 5.0 : model.rating
        nameAuthorLabel.text = "от \(model.nameAuthor.split(separator: ".")[0])"
        priceValueLabel.text = "\(model.priceETN) ETN"
    }
    
    func likeButttonPulse(flag: Bool) {
        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 0.8
        pulse1.fromValue = 0.8
        pulse1.toValue = 1.2
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.8

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.5
        animationGroup.repeatCount = 1000
        animationGroup.animations = [pulse1]

        flag ?
        likeButton.layer.add(animationGroup, forKey: "pulse")
        : likeButton.layer.removeAnimation(forKey: "pulse")
    }
}
