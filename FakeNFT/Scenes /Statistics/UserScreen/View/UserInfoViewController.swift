import UIKit

final class UserInfoViewController: UIViewController {
    private let viewModel: UserInfoViewModelProtocol

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.segmentActive
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private lazy var userDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.segmentActive
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var userWebsiteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.segmentActive.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.setTitle(
            NSLocalizedString(
                "UserWebsite.button",
                comment: "goto user website"
            ),
            for: .normal)
        button.setTitleColor(UIColor.segmentActive, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.backgroundColor = UIColor.whiteModeThemes
        return button
    }()

    private lazy var nftCollectionButtonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Коллекция NFT (112)"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .segmentActive
        return label
    }()

    private lazy var nftCollectionButtonImageView: UIImageView = {
        let image = UIImage(named: "forward")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nftCollectionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapNFTCollection), for: .touchUpInside)
        return button
    }()

    init(user: User, viewModel: UserInfoViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        usernameLabel.text = user.username
        userDescription.text = user.description
        avatarImageView.image = user.avatar
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteModeThemes

        setupViewModel()
        setupUI()
    }

    @objc private func didTapNFTCollection() {
        viewModel.nftCollectionButtonDidTap()
    }

    private func setupViewModel() {
        viewModel.onNFTCollectionButtonTap = { [weak self] in
            self?.pushNFTColletionViewController()
        }
    }

    private func setupUI() {
        setupNavBar()
        setupAvatarImageView()
        setupUsernameLabel()
        setupUserDescription()
        setupUserWebsiteButton()
        setupNFTCollectionButton()
    }

    private func setupUsernameLabel() {
        view.addSubview(usernameLabel)
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: Constants.defaultInset
            ),
            usernameLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.defaultInset
            ),
            usernameLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.defaultElementSpacing
            )
        ])
    }

    private func setupUserDescription() {
        view.addSubview(userDescription)
        NSLayoutConstraint.activate([
            userDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultInset),
            userDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultInset),
            userDescription.topAnchor.constraint(
                equalTo: usernameLabel.bottomAnchor,
                constant: Constants.defaultElementSpacing
            )
        ])
    }

    private func setupNavBar() {
        let backButton = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        backButton.tintColor = UIColor.segmentActive
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    private func setupAvatarImageView() {
        view.addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.userAvatarHeight),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.userAvatarWidth),
            avatarImageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.defaultInset
            ),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    private func setupUserWebsiteButton() {
        view.addSubview(userWebsiteButton)
        NSLayoutConstraint.activate([
            userWebsiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultInset),
            userWebsiteButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.defaultInset
            ),
            userWebsiteButton.topAnchor.constraint(equalTo: userDescription.bottomAnchor, constant: 28),
            userWebsiteButton.heightAnchor.constraint(equalToConstant: Constants.userWebsiteButtonHeight)
        ])
    }

    private func setupNFTCollectionButton() {
        view.addSubview(nftCollectionButton)
        nftCollectionButton.addSubview(nftCollectionButtonLabel)
        nftCollectionButton.addSubview(nftCollectionButtonImageView)

        NSLayoutConstraint.activate([
            nftCollectionButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.defaultInset
            ),
            nftCollectionButton.topAnchor.constraint(
                equalTo: userWebsiteButton.bottomAnchor,
                constant: Constants.defaultElementSpacing
            ),
            nftCollectionButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.defaultInset)
        ])

        NSLayoutConstraint.activate([
            nftCollectionButtonLabel.leadingAnchor.constraint(equalTo: nftCollectionButton.leadingAnchor),
            nftCollectionButtonLabel.centerYAnchor.constraint(equalTo: nftCollectionButton.centerYAnchor),

            nftCollectionButtonImageView.trailingAnchor.constraint(equalTo: nftCollectionButton.trailingAnchor),
            nftCollectionButtonImageView.centerYAnchor.constraint(equalTo: nftCollectionButton.centerYAnchor)
        ])
    }

    private func pushNFTColletionViewController() {
        let viewModel = NFTCollectionViewModel(for: NFTModel())
        navigationController?.pushViewController(
            NFTCollectionViewController(viewModel: viewModel),
            animated: true)
    }
}

private enum Constants {
    static let userAvatarHeight: CGFloat = 70
    static let userAvatarWidth: CGFloat = 70
    static let defaultInset: CGFloat = 16
    static let defaultElementSpacing: CGFloat = 40
    static let userWebsiteButtonHeight: CGFloat = 40
}
