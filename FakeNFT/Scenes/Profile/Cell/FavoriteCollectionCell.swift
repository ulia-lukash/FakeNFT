//
//  FavoriteCollectionCell.swift
//  FakeNFT
//
//  Created by Григорий Машук on 26.02.24.
//

import Kingfisher
import UIKit

protocol FavoriteCollectionCellDelegate: AnyObject {
    func likeTap(_ cell: UICollectionViewCell)
}

// MARK: - FavoriteCollectionCell
final class FavoriteCollectionCell: UICollectionViewCell, ReuseIdentifying {
    private enum ConstantsCell: String {
        static let imageCornerRadius = CGFloat(12)
        case favouritesIcons
    }
    
    weak var delegate: FavoriteCollectionCellDelegate?
    
    private lazy var horisontalStackView: UIStackView = {
        let horisontalStackView = UIStackView()
        horisontalStackView.axis = .horizontal
        horisontalStackView.spacing = 8
        horisontalStackView.isUserInteractionEnabled = true
        horisontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horisontalStackView.backgroundColor = .clear
        horisontalStackView.alignment = .center
        
        return horisontalStackView
    }()
    
    private lazy var nftImageView: UIImageView = {
        let nftImageView = UIImageView()
        nftImageView.layer.cornerRadius = ConstantsCell.imageCornerRadius
        nftImageView.layer.masksToBounds = true
        nftImageView.isUserInteractionEnabled = true
        
        return nftImageView
    }()
    
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.backgroundColor = .clear
        likeButton.isUserInteractionEnabled = true
        let image = UIImage(named: ConstantsCell.favouritesIcons.rawValue)
        likeButton.tintColor = Asset.Colors.red.color
        likeButton.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        likeButton.addTarget(self, action: #selector(didLike), for: .touchUpInside)
        
        return likeButton
    }()
    
    private lazy var nftView = UIView()
    
    private lazy var nameNFTLabel: UILabel = {
        let nameNFTLabel = UILabel()
        nameNFTLabel.font = .SF17bold
        nameNFTLabel.textColor = Asset.Colors.black.color
        
        return nameNFTLabel
    }()
    
    private lazy var ratingView = RatingView()
    
    private lazy var priceValueLabel: UILabel = {
        let priceValueLabel = UILabel()
        priceValueLabel.textAlignment = .center
        priceValueLabel.textColor = Asset.Colors.black.color
        priceValueLabel.font = .SF15regular
        
        return priceValueLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUiItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavoriteCollectionCell {
    // MARK: private func
    @objc
    private func didLike() {
        guard let delegate else { return }
        delegate.likeTap(self)
    }
    
    private func setupUiItem() {
        addSubViews()
        setupConstrains()
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            horisontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horisontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horisontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horisontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            nftImageView.heightAnchor.constraint(equalToConstant: 80),
            nftImageView.widthAnchor.constraint(equalToConstant: 80),
            
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 8),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: -8),
            
            nameNFTLabel.topAnchor.constraint(equalTo: nftView.topAnchor),
            nameNFTLabel.leadingAnchor.constraint(equalTo: nftView.leadingAnchor),
            nameNFTLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            nftView.heightAnchor.constraint(equalToConstant: 66),
            
            ratingView.leadingAnchor.constraint(equalTo: nftView.leadingAnchor),
            ratingView.centerYAnchor.constraint(equalTo: nftView.centerYAnchor),
            priceValueLabel.bottomAnchor.constraint(equalTo: nftView.bottomAnchor),
            priceValueLabel.leadingAnchor.constraint(equalTo: nftView.leadingAnchor)
        ])
    }
    
    private func addSubViews() {
        addSubview(horisontalStackView)
        nftImageView.addSubview(likeButton)
        [nftImageView, nftView].forEach {
            horisontalStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
        [nameNFTLabel, ratingView, priceValueLabel].forEach {
            nftView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
    }
    
    func config(model: FavCollCellModel) {
        nftImageView.kf.setImage(with: model.urlNFT)
        nameNFTLabel.text = model.nameNFT.components(separatedBy: " ").first
        ratingView.rating = model.rating >= 5.0 ? 5.0 : model.rating
        priceValueLabel.text = "\(model.priceETN) ETN"
    }
}
