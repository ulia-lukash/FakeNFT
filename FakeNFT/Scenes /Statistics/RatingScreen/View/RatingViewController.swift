import UIKit

final class RatingViewController: UIViewController {
    private let viewModel: RatingViewModelProtocol

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = Constants.tableViewRowHeight
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    init(viewModel: RatingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupViewModel()
        setupNavBar()
        setupTableView()
    }

    private func setupViewModel() {
        viewModel.onSortButtonTap = { [weak self] in
            self?.presentSortAlertController()
        }
        viewModel.onUsersListChange = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.onUserProfileDidTap = { [weak self] user in
            self?.pushUserInfoViewController(withUser: user)
        }
    }

    private func setupNavBar() {
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(),
            for: UIBarPosition.any,
            barMetrics: UIBarMetrics.default
        )
        navigationController?.navigationBar.shadowImage = UIImage()

        let sortButton = UIBarButtonItem(
            image: UIImage(named: "sortButton"),
            style: .plain,
            target: self,
            action: #selector(Self.sortButtonDidTap))
        sortButton.tintColor = UIColor.segmentActive

        navigationItem.rightBarButtonItem = sortButton
    }

    private func setupTableView() {
        tableView.register(RatingCell.self, forCellReuseIdentifier: "ratingCell")
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.tableViewHorizontalInset
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.tableViewHorizontalInset)
        ])
    }

    @objc private func sortButtonDidTap() {
        viewModel.sortButtonDidTap()
    }

    private func presentSortAlertController() {
        let alert = UIAlertController(
            title: NSLocalizedString("SortAlert.title", comment: "sort alert title"),
            message: nil,
            preferredStyle: .actionSheet
        )

        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Sort.byName", comment: "sort user by name"),
            style: .default
        ) { [weak self] _ in
            self?.viewModel.sortByNameDidTap()
        })

        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Sort.byRating", comment: "sort user by rating"),
            style: .default
        ) { [weak self] _ in
            self?.viewModel.sortByRatingDidTap()
        })

        alert.addAction(UIAlertAction(
            title: NSLocalizedString("SortAlert.close", comment: "close alert"),
            style: .cancel) { _ in })

        present(alert, animated: true, completion: nil)
    }

    private func pushUserInfoViewController(withUser user: User) {
        navigationController?.pushViewController(UserInfoViewController(user: user), animated: true)
    }
}

extension RatingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.allUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as? RatingCell

        let user = viewModel.allUsers[indexPath.row]
        cell?.setupCell(userData: user)

        guard let cell = cell else {
            return RatingCell()
        }

        return cell
    }
}

extension RatingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.userProfileDidTap(withIndex: indexPath)
    }
}

private enum Constants {
    static let tableViewHorizontalInset: CGFloat = 16
    static let tableViewTopInset: CGFloat = 12
    static let tableViewRowHeight: CGFloat = 88
}
