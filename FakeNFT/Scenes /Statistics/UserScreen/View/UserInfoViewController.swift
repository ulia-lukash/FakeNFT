import UIKit

final class UserInfoViewController: UIViewController {
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.segmentActive
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private let userDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.segmentActive
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init(user: User) {
        usernameLabel.text = user.username
        userDescription.text = user.description
        avatarImageView.image = user.avatar
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupNavBar()
        setupAvatarImageView()
        setupUsernameLabel()
        setupUserDescription()
    }

    private func setupUsernameLabel() {
        view.addSubview(usernameLabel)
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 41)
        ])
    }

    private func setupUserDescription() {
        view.addSubview(userDescription)
        NSLayoutConstraint.activate([
            userDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            userDescription.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 41)
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
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
}

private enum Constants {
    static let userAvatarHeight: CGFloat = 70
    static let userAvatarWidth: CGFloat = 70
}
