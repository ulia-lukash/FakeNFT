import UIKit
import Kingfisher

protocol NFTCellProtocol: AnyObject {
    func likeButtonDidTap(nftId: String, isLiked: Bool)
    func basketButtonDidTap(nftId: String, isOrdered: Bool)
}

final class NFTCell: UICollectionViewCell {
    weak var delegate: NFTCellProtocol?

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .SF10medium
        label.textColor = Asset.Colors.black.color
        return label
    }()

    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .SF17bold
        label.textColor = Asset.Colors.black.color
        return label
    }()

    private lazy var ratingView = RatingView()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()

    private lazy var basketButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "tabler_trash"), for: .normal)
        button.addTarget(self, action: #selector(didTapBasketButton), for: .touchUpInside)
        return button
    }()

    private var nftRating: Double = 0 {
        didSet {
            updateRatingStarViews()
        }
    }

    private var isLiked = false {
        didSet {
            updateLikeButtonImage()
        }
    }

    private var nftId: String = ""

    private var inBasket = false {
        didSet {
            updateBasketButtonImage()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(using nft: NFT) {
        nftRating = nft.rating
        nftImageView.kf.setImage(with: nft.image.first)
        nftPriceLabel.text = nft.price + " ETH"
        nftNameLabel.text = nft.name
        isLiked = nft.isLiked
        nftId = nft.id
        inBasket = nft.isOrdered
    }

    private func setupUI() {
        setupNFTImageView()
        setupLikeButton()
        setupNFTRatingStackView()
        setupNFTNameLabel()
        setupNFTPriceLabel()
        setupBasketButton()
    }

    private func setupNFTImageView() {
        contentView.addSubview(nftImageView)
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.imageHeight),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setupLikeButton() {
        contentView.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.likeImageViewInset
            ),
            likeButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.likeImageViewInset
            )
        ])
    }

    private func setupNFTRatingStackView() {
        contentView.addSubview(ratingView)
        updateRatingStarViews()
        NSLayoutConstraint.activate([
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.topAnchor.constraint(
                equalTo: nftImageView.bottomAnchor,
                constant: Constants.ratingStackTopInset
            )
        ])
    }

    private func setupNFTNameLabel() {
        contentView.addSubview(nftNameLabel)
        NSLayoutConstraint.activate([
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftNameLabel.topAnchor.constraint(
                equalTo: ratingView.bottomAnchor,
                constant: Constants.nameTopInset
            )
        ])
    }

    private func setupNFTPriceLabel() {
        contentView.addSubview(nftPriceLabel)
        NSLayoutConstraint.activate([
            nftPriceLabel.topAnchor.constraint(
                equalTo: nftNameLabel.bottomAnchor,
                constant: Constants.priceTopInset
            ),
            nftPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }

    private func setupBasketButton() {
        contentView.addSubview(basketButton)
        NSLayoutConstraint.activate([
            basketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basketButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.basketBottomInset
            ),
            basketButton.heightAnchor.constraint(equalToConstant: Constants.basketHeight),
            basketButton.widthAnchor.constraint(equalToConstant: Constants.basketWidth)
        ])
    }

    private func updateRatingStarViews() {
        ratingView.rating = nftRating > 5 ? 5 : nftRating
    }

    private func updateBasketButtonImage() {
        let image = inBasket ? UIImage(named: "tabler_trash-x") : UIImage(named: "tabler_trash")
        basketButton.setImage(image, for: .normal)
    }

    private func updateLikeButtonImage() {
        likeButton.tintColor = isLiked ? Asset.Colors.red.color : Asset.Colors.whiteUniversal.color
    }

    @objc private func didTapLikeButton() {
        isLiked.toggle()
        delegate?.likeButtonDidTap(nftId: nftId, isLiked: isLiked)
    }

    @objc private func didTapBasketButton() {
        inBasket.toggle()
        delegate?.basketButtonDidTap(nftId: nftId, isOrdered: inBasket)
    }
}

private enum Constants {
    static let likeImageViewInset: CGFloat = 12
    static let imageHeight: CGFloat = 108
    static let contentBottomInset: CGFloat = 21
    static let ratingStackTopInset: CGFloat = 8
    static let nameTopInset: CGFloat = 5
    static let priceTopInset: CGFloat = 4
    static let basketBottomInset: CGFloat = 20
    static let basketWidth: CGFloat = 40
    static let basketHeight: CGFloat = 40
}
