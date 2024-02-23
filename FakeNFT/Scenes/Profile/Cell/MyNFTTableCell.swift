//
//  MyNFTTableCell.swift
//  FakeNFT
//
//  Created by Григорий Машук on 18.02.24.
//

import Kingfisher
import Cosmos
import UIKit

final class MyNFTTableCell: UITableViewCell {
    private enum ConstMyNFTCell: String {
        static let imageCornerRadius = CGFloat(12)
        case favouritesIcons
    }
    
    private lazy var horisontalStackView: UIStackView = {
        let horisontalStackView = UIStackView()
        
        return horisontalStackView
    }()
    
    private lazy var nftImageView: UIImageView = {
        let nftImageView = UIImageView()
        
        return nftImageView
    }()
    
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        
        return likeButton
    }()
    
    private lazy var nameNFTView: UIView = {
        let nameNFTView = UIView()
        
        return nameNFTView
    }()
    
    private lazy var nameNFTLabel: UILabel = {
        let nameNFTLabel = UILabel()
        
        return nameNFTLabel
    }()
    
    private lazy var starRatingView: CosmosView = {
        let starRatingView = CosmosView()
        
        return starRatingView
    }()
    
    private lazy var horisontaNameStack: UIStackView = {
        let horisontaNameStack = UIStackView()
        
        return horisontaNameStack
    }()
    
    private lazy var fromLabel: UILabel = {
        let fromLabel = UILabel()
        
        return fromLabel
    }()
    
    private lazy var nameAuthorLabel: UILabel = {
        let nameAuthorLabel = UILabel()
        
        return nameAuthorLabel
    }()
    
    private lazy var priceView: UIView = {
        let priceView = UIView()
        
        return priceView
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.text = ConstLocalizable.profileCellMyNFT
        
        return priceLabel
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let priceValueLabel = UILabel()
        
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
        super.prepareForReuse()
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        nftImageView.kf.cancelDownloadTask()
        
    }
}

extension MyNFTTableCell {
    private func setupUIItem() {
        setupHorisontalStack()
        setupNftImageView()
        setupLikeButton()
        setupnameNFTView()
        setupHorisontaNameStack()
        setupNameNFTLabel()
        setupNameUserLabel()
        setupRatingView()
        setupFromLabel()
        setupPriceView()
        setupPriceLabel()
        setupPriceValueLabel()
    }
    
    private func setupHorisontalStack() {
        addSubview(horisontalStackView)
        [nftImageView, nameNFTView, priceView].forEach {
            horisontalStackView.addArrangedSubview($0)
        }
        horisontalStackView.axis = .horizontal
        horisontalStackView.spacing = 20
        horisontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horisontalStackView.backgroundColor = .clear
        horisontalStackView.alignment = .center
        
        NSLayoutConstraint.activate([
            horisontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            horisontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            horisontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            horisontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func setupNftImageView() {
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        nftImageView.backgroundColor = .clear
        nftImageView.layer.cornerRadius = ConstMyNFTCell.imageCornerRadius
        nftImageView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108)
        ])
    }
    
    private func setupLikeButton() {
        nftImageView.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.backgroundColor = .clear
        let image = UIImage(named: ConstMyNFTCell.favouritesIcons.rawValue)
        likeButton.setImage(image, for: .normal)
        likeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        NSLayoutConstraint.activate([
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor)
        ])
    }
    
    private func setupnameNFTView() {
        nameNFTView.translatesAutoresizingMaskIntoConstraints = false
        nameNFTView.backgroundColor = .clear
        nameNFTView.heightAnchor.constraint(equalToConstant: 62).isActive = true
    }
    
    private func setupNameNFTLabel() {
        nameNFTView.addSubview(nameNFTLabel)
        nameNFTLabel.translatesAutoresizingMaskIntoConstraints = false
        nameNFTLabel.backgroundColor = .clear
        nameNFTLabel.font = .headline5
        nameNFTLabel.textColor = .blackUniversal
        
        NSLayoutConstraint.activate([
            nameNFTLabel.topAnchor.constraint(equalTo: nameNFTView.topAnchor),
            nameNFTLabel.leadingAnchor.constraint(equalTo: nameNFTView.leadingAnchor),
            nameNFTLabel.trailingAnchor.constraint(equalTo: nameNFTView.trailingAnchor)
        ])
    }
    
    private func setupRatingView() {
        nameNFTView.addSubview(starRatingView)
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        starRatingView.backgroundColor = .clear
        starRatingView.rating = 4
        starRatingView.settings.filledColor = .yellowUniversal
        starRatingView.settings.starMargin = 1
        starRatingView.settings.emptyColor = .lightGreyUniversal
        starRatingView.settings.emptyBorderColor = .clear
        starRatingView.settings.filledBorderColor = .clear
        
        NSLayoutConstraint.activate([
            starRatingView.topAnchor.constraint(equalTo: nameNFTLabel.bottomAnchor, constant: 4),
            starRatingView.leadingAnchor.constraint(equalTo: nameNFTView.leadingAnchor),
            starRatingView.trailingAnchor.constraint(equalTo: nameNFTView.trailingAnchor, constant: -10),
            starRatingView.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
    
    private func setupHorisontaNameStack() {
        nameNFTView.addSubview(horisontaNameStack)
        [fromLabel, nameAuthorLabel].forEach {
            horisontaNameStack.addArrangedSubview($0)
        }
        horisontaNameStack.spacing = 4
        horisontaNameStack.translatesAutoresizingMaskIntoConstraints = false
        horisontaNameStack.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            horisontaNameStack.leadingAnchor.constraint(equalTo: nameNFTView.leadingAnchor),
            horisontaNameStack.trailingAnchor.constraint(equalTo: nameNFTView.trailingAnchor),
            horisontaNameStack.bottomAnchor.constraint(equalTo: nameNFTView.bottomAnchor)
        ])
    }
    
    private func setupFromLabel() {
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.backgroundColor = .clear
        fromLabel.font = .caption1
        fromLabel.text = ConstLocalizable.myNFTCellFrom
        fromLabel.textColor = .blackUniversal
        fromLabel.textAlignment = .left
        let width = fromLabel.text?.width(withConstrainedHeight: 20, font: .caption1)
        fromLabel.widthAnchor.constraint(equalToConstant: width ?? 20).isActive = true
    }
    
    private func setupNameUserLabel() {
        nameAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        nameAuthorLabel.font = .caption2
        nameAuthorLabel.backgroundColor = .clear
        nameAuthorLabel.textColor = .blackUniversal
        nameAuthorLabel.textAlignment = .left
    }
    
    private func setupPriceView() {
        priceView.translatesAutoresizingMaskIntoConstraints = false
        priceView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            priceView.heightAnchor.constraint(equalToConstant: 42),
            priceView.widthAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setupPriceLabel() {
        priceView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.backgroundColor = .clear
        priceLabel.text = ConstLocalizable.myNFTCellPrice
        priceLabel.textColor = .blackUniversal
        priceLabel.font = .caption2
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: priceView.topAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor)
        ])
    }
    
    private func setupPriceValueLabel() {
        priceView.addSubview(priceValueLabel)
        priceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        priceValueLabel.textAlignment = .center
        priceValueLabel.textColor = .blackUniversal
        priceValueLabel.font = .bodyBold
        
        NSLayoutConstraint.activate([
            priceValueLabel.bottomAnchor.constraint(equalTo: priceView.bottomAnchor),
            priceValueLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor),
            priceValueLabel.trailingAnchor.constraint(equalTo: priceView.trailingAnchor)
        ])
    }
    
    func config(model: MyNFTCellModel) {
        nftImageView.kf.setImage(with: model.urlNFT)
        nameNFTLabel.text = model.nameNFT.components(separatedBy: " ").first
        starRatingView.rating = model.rating >= 5.0 ? 5.0 : model.rating
        nameAuthorLabel.text = model.nameAuthor
        priceValueLabel.text = "\(model.priceETN) ETN"
    }
}
