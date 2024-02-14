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
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupNavBar()
        setupTableView()
    }

    private func setupNavBar() {
        let sortButton = UIBarButtonItem(
            image: UIImage(named: "sortButton"),
            style: .plain,
            target: nil,
            action: nil)
        sortButton.tintColor = UIColor.segmentActive

        navigationItem.rightBarButtonItem = sortButton
    }

    private func setupTableView() {
        tableView.register(RatingCell.self, forCellReuseIdentifier: "ratingCell")
        tableView.rowHeight = Constants.tableViewRowHeight
        tableView.separatorStyle = .none
        tableView.dataSource = self

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.tableViewInset
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.tableViewInset)
        ])
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
    static let tableViewInset: CGFloat = 16
    static let tableViewRowHeight: CGFloat = 88
}
