import UIKit

final class RatingViewController: UIViewController {
    private let mockUsernames = ["Alex", "Bill", "Alla", "Mads", "Timothèe", "Lea", "Eric", "Somebody"]
    private let mockNFTAmount = ["112", "98", "72", "71", "51", "23", "11", "0"]
    private let mockAvatars = [
        UIImage(named: "UserpickAlex"),
        UIImage(named: "noAvatar"),
        UIImage(named: "noAvatar"),
        UIImage(named: "UserpickMads"),
        UIImage(named: "UserpickTimon"),
        UIImage(named: "UserpickLea"),
        UIImage(named: "UserpickEric"),
        UIImage(named: "noAvatar")
    ]

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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupNavBar()
        setupTableView()
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
            action: #selector(Self.presentSortAlertController))
        sortButton.tintColor = UIColor.segmentActive

        navigationItem.rightBarButtonItem = sortButton
    }

    private func setupTableView() {
        tableView.register(RatingCell.self, forCellReuseIdentifier: "ratingCell")
        tableView.dataSource = self

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

    @objc private func presentSortAlertController() {
        let alert = UIAlertController(
            title: NSLocalizedString("SortAlert.title", comment: "sort alert title"),
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Sort.byName", comment: "sort user by name"),
            style: .default) { _ in })

        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Sort.byRating", comment: "sort user by rating"),
            style: .default) { _ in })

        alert.addAction(UIAlertAction(
            title: NSLocalizedString("SortAlert.close", comment: "close alert"),
            style: .cancel) { _ in })

        present(alert, animated: true, completion: nil)
    }
}

extension RatingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mockUsernames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as? RatingCell

        let rating = String(indexPath.row + 1)
        let username = mockUsernames[indexPath.row]
        // swiftlint:disable:next force_unwrapping
        let avatar = mockAvatars[indexPath.row] ?? UIImage(systemName: "person.crop.circle")!
        let nftAmount = mockNFTAmount[indexPath.row]

        cell?.setupCell(
            rating: rating,
            username: username,
            avatar: avatar,
            nftAmount: nftAmount)

        guard let cell = cell else {
            return RatingCell()
        }

        return cell
    }
}

private enum Constants {
    static let tableViewHorizontalInset: CGFloat = 16
    static let tableViewTopInset: CGFloat = 12
    static let tableViewRowHeight: CGFloat = 88
}
