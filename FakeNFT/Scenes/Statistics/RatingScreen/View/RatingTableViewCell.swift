import UIKit

final class RatingCell: UITableViewCell {
    private lazy var subView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.segmentInactive
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var ratingPositionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        label.textAlignment = .center
        return label
    }()

    private lazy var avatarImageView: UIImageView = {
        let image = UIImage(named: "Userpick")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Alex"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private lazy var nftAmoutLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "112"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .right
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        setupRatingPositionLabel()
        setupBackgroundView()
        setupAvatarImageView()
        setupUsernameLabel()
        setupNFTAmountLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBackgroundView() {
        contentView.addSubview(subView)
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: contentView.topAnchor),
            subView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            subView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.subViewInset)
        ])
    }

    private func setupRatingPositionLabel() {
        contentView.addSubview(ratingPositionLabel)
        NSLayoutConstraint.activate([
            ratingPositionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ratingPositionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingPositionLabel.heightAnchor.constraint(equalToConstant: Constants.ratingPositionLabelHeight),
            ratingPositionLabel.widthAnchor.constraint(equalToConstant: Constants.ratingPositionLabelWidth)
        ])
    }

    private func setupAvatarImageView() {
        subView.addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(
                equalTo: subView.leadingAnchor, constant: Constants.cellElementInset
            ),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.cellElementHeight),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarImageViewWidth)
        ])
    }

    private func setupUsernameLabel() {
        subView.addSubview(usernameLabel)
        NSLayoutConstraint.activate([
            usernameLabel.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            usernameLabel.heightAnchor.constraint(equalToConstant: Constants.cellElementHeight)
        ])
    }

    private func setupNFTAmountLabel() {
        subView.addSubview(nftAmoutLabel)
        NSLayoutConstraint.activate([
            nftAmoutLabel.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            nftAmoutLabel.leadingAnchor.constraint(
                equalTo: usernameLabel.trailingAnchor, constant: Constants.cellElementInset),
            nftAmoutLabel.trailingAnchor.constraint(
                equalTo: subView.trailingAnchor, constant: -Constants.cellElementInset
            ),
            nftAmoutLabel.heightAnchor.constraint(equalToConstant: Constants.cellElementHeight)
        ])
    }

    func setupCell(
        user: User
    ) {
        ratingPositionLabel.text = String(user.rating)
        avatarImageView.kf.setImage(with: user.avatar, placeholder: UIImage(named: "noAvatar"))
        usernameLabel.text = user.username
        nftAmoutLabel.text = String(user.nfts.count)
    }
}

private enum Constants {
    static let subViewInset: CGFloat = 35
    static let cellElementInset: CGFloat = 16
    static let cellElementHeight: CGFloat = 28
    static let ratingPositionLabelHeight: CGFloat = 20
    static let ratingPositionLabelWidth: CGFloat = 27
    static let avatarImageViewWidth: CGFloat = 28
}
