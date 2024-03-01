import UIKit
import Kingfisher

final class NFTCell: UICollectionViewCell {
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
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .segmentActive
        return label
    }()

    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .segmentActive
        return label
    }()

    private lazy var nftRatingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = Constants.ratingStarsSpacing
        return stackView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "noLike"), for: .normal)
        button.setImage(UIImage(named: "like"), for: .selected)
        button.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
        return button
    }()

    private lazy var basketButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "basket"), for: .normal)
        button.addTarget(self, action: #selector(didTapBasketButton), for: .touchUpInside)
        return button
    }()

    private var nftRating = 0 {
        didSet {
            updateRatingStarViews()
        }
    }

    private var isLiked = false {
        didSet {
            changeLikeButtonState()
        }
    }

    private var inBasket = false {
        didSet {
            changeBasketButtonState()
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
        contentView.addSubview(nftRatingStackView)
        updateRatingStarViews()
        NSLayoutConstraint.activate([
            nftRatingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftRatingStackView.topAnchor.constraint(
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
                equalTo: nftRatingStackView.bottomAnchor,
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
        if !nftRatingStackView.arrangedSubviews.isEmpty {
            nftRatingStackView.arrangedSubviews.forEach { subView in
                nftRatingStackView.removeArrangedSubview(subView)
                subView.removeFromSuperview()
            }
        }

        for i in 1...5 {
            let starImageView = UIImageView()
            starImageView.image = i <= nftRating ? UIImage(named: "filledStar") : UIImage(named: "unfilledStar")
            starImageView.contentMode = .scaleAspectFit
            nftRatingStackView.addArrangedSubview(starImageView)
        }
    }

    private func changeLikeButtonState() {
        let image = isLiked ? UIImage(named: "like") : UIImage(named: "noLike")
        likeButton.setImage(image, for: .normal)
    }

    private func changeBasketButtonState() {
        let image = inBasket ? UIImage(named: "basketX") : UIImage(named: "basket")
        basketButton.setImage(image, for: .normal)
    }

    @objc private func toggleLike() {
        isLiked.toggle()
    }

    @objc private func didTapBasketButton() {
        inBasket.toggle()
    }
}

private enum Constants {
    static let likeImageViewInset: CGFloat = 12
    static let imageHeight: CGFloat = 108
    static let contentBottomInset: CGFloat = 21
    static let ratingStarsSpacing: CGFloat = 2
    static let ratingStackTopInset: CGFloat = 8
    static let nameTopInset: CGFloat = 5
    static let priceTopInset: CGFloat = 4
    static let basketBottomInset: CGFloat = 20
    static let basketWidth: CGFloat = 40
    static let basketHeight: CGFloat = 40
}
