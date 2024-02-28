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

//MARK: MyNFTTableCell
final class MyNFTTableCell: UITableViewCell {
    private enum ConstMyNFTCell: String {
        static let imageCornerRadius = CGFloat(12)
        case favouritesIcons
    }
    
    weak var delegate: MyNFTTableCellDelegate?
    
    private lazy var horisontalStackView: UIStackView = {
        let horisontalStackView = UIStackView()
        horisontalStackView.axis = .horizontal
        horisontalStackView.spacing = 20
        horisontalStackView.isUserInteractionEnabled = true
        horisontalStackView.alignment = .center
        
        return horisontalStackView
    }()
    
    private lazy var nftImageView: UIImageView = {
        let nftImageView = UIImageView()
        nftImageView.layer.cornerRadius = ConstMyNFTCell.imageCornerRadius
        nftImageView.layer.masksToBounds = true
        nftImageView.isUserInteractionEnabled = true
        
        return nftImageView
    }()
    
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.isUserInteractionEnabled = true
        let image = UIImage(
            named: ConstMyNFTCell.favouritesIcons.rawValue)?.withRenderingMode(.alwaysTemplate)
        likeButton.setImage(image, for: .normal)
        likeButton.addTarget(self, action: #selector(didLike), for: .touchUpInside)
        
        return likeButton
    }()
    
    private lazy var nameNFStackTView: UIStackView = {
        let nameNFStackTView = UIStackView()
        nameNFStackTView.axis = .vertical
        nameNFStackTView.spacing = 6
        
        return nameNFStackTView
    }()
    
    private lazy var nameNFTLabel: UILabel = {
        let nameNFTLabel = UILabel()
        nameNFTLabel.font = .bodyBold
        nameNFTLabel.textColor = .blackUniversal
        
        return nameNFTLabel
    }()
    
    private lazy var starRatingView: CosmosView = {
        let starRatingView = CosmosView()
        starRatingView.rating = 0
        starRatingView.settings.starSize = 16
        starRatingView.settings.filledColor = .yellowUniversal
        starRatingView.settings.starMargin = 1
        starRatingView.settings.emptyColor = .lightGreyUniversal
        starRatingView.settings.emptyBorderColor = .clear
        starRatingView.settings.filledBorderColor = .clear
        
        return starRatingView
    }()
    
    private lazy var horisontaNameStack: UIStackView = {
        let horisontaNameStack = UIStackView()
        horisontaNameStack.spacing = 4
        
        return horisontaNameStack
    }()
    
    private lazy var fromLabel: UILabel = {
        let fromLabel = UILabel()
        fromLabel.font = .caption1
        fromLabel.text = ConstLocalizable.myNftCellFrom
        fromLabel.textColor = .blackUniversal
        fromLabel.textAlignment = .left
        
        return fromLabel
    }()
    
    private lazy var nameAuthorLabel: UILabel = {
        let nameAuthorLabel = UILabel()
        nameAuthorLabel.font = .caption2
        nameAuthorLabel.textColor = .blackUniversal
        nameAuthorLabel.textAlignment = .left
        
        return nameAuthorLabel
    }()
    
    private lazy var priceView: UIView = {
        let priceView = UIView()
        
        return priceView
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.text = ConstLocalizable.profileCellMyNFT
        priceLabel.text = ConstLocalizable.myNftCellPrice
        priceLabel.textColor = .blackUniversal
        priceLabel.font = .caption2
        
        return priceLabel
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let priceValueLabel = UILabel()
        priceValueLabel.textAlignment = .center
        priceValueLabel.textColor = .blackUniversal
        priceValueLabel.font = .bodyBold
        
        return priceValueLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        isUserInteractionEnabled = true
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
    //MARK: private @objc func
    @objc
    private func didLike() {
        guard let delegate else { return }
        delegate.likeTap(self)
    }
    
    //MARK: private func
    private func setupUIItem() {
        setupHorisontalStack()
        addSubviews()
        setupConstraint()
        setupAutoresizingMaskAndBackColor()
    }
    
    func setupAutoresizingMaskAndBackColor() {
        [horisontalStackView, likeButton, nameNFStackTView,
         nameNFTLabel, horisontaNameStack, fromLabel,
         nameAuthorLabel, priceLabel, priceValueLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
    }
    
    private func setupConstraint() {
        let width = fromLabel.text?.width(withConstrainedHeight: 20, font: .caption1)
        NSLayoutConstraint.activate([
            horisontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            horisontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            horisontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            horisontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            nameNFStackTView.heightAnchor.constraint(equalToConstant: 62),
            nameNFTLabel.topAnchor.constraint(equalTo: nameNFStackTView.topAnchor),
            nameNFTLabel.leadingAnchor.constraint(equalTo: nameNFStackTView.leadingAnchor),
            nameNFTLabel.trailingAnchor.constraint(equalTo: nameNFStackTView.trailingAnchor),
            horisontaNameStack.leadingAnchor.constraint(equalTo: nameNFStackTView.leadingAnchor),
            horisontaNameStack.trailingAnchor.constraint(equalTo: nameNFStackTView.trailingAnchor),
            horisontaNameStack.bottomAnchor.constraint(equalTo: nameNFStackTView.bottomAnchor),
            fromLabel.widthAnchor.constraint(equalToConstant: width ?? 20),
            priceView.heightAnchor.constraint(equalToConstant: 42),
            priceView.widthAnchor.constraint(equalToConstant: 100),
            priceLabel.topAnchor.constraint(equalTo: priceView.topAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor),
            priceValueLabel.bottomAnchor.constraint(equalTo: priceView.bottomAnchor),
            priceValueLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor),
            priceValueLabel.trailingAnchor.constraint(equalTo: priceView.trailingAnchor),
            starRatingView.leadingAnchor.constraint(equalTo: nameNFStackTView.leadingAnchor),
            starRatingView.centerYAnchor.constraint(equalTo: nameNFStackTView.centerYAnchor),
            starRatingView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func addSubviews() {
        contentView.addSubview(horisontalStackView)
        nftImageView.addSubview(likeButton)
        [fromLabel, nameAuthorLabel].forEach {
            horisontaNameStack.addArrangedSubview($0)
        }
        [nameNFTLabel, starRatingView, horisontaNameStack].forEach {
            nameNFStackTView.addArrangedSubview($0)
        }
        [priceLabel, priceValueLabel].forEach {
            priceView.addSubview($0)
        }
    }
    
    private func setupHorisontalStack() {
        [nftImageView, nameNFStackTView, priceView].forEach {
            horisontalStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
    }
    
    func like(flag: Bool) {
        likeButton.tintColor = flag ? .white : .redUniversal
    }
    
    func config(model: MyNFTCellModel) {
        nftImageView.kf.setImage(with: model.urlNFT)
        nameNFTLabel.text = model.nameNFT.components(separatedBy: " ").first
        starRatingView.rating = model.rating >= 5.0 ? 5.0 : model.rating
        nameAuthorLabel.text = model.nameAuthor
        priceValueLabel.text = "\(model.priceETN) ETN"
    }
}
