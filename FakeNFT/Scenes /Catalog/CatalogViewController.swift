//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 11.02.2024.
//

import Foundation
import UIKit
import ProgressHUD

final class CatalogViewController: UIViewController {

    private var viewModel: CatalogViewModelProtocol?
    private lazy var burgerButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "text.justify.leading")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.segmentActive
        button.addTarget(self, action: #selector(didPressBurgerButton), for: .touchUpInside)
        return button
    }()

    private lazy var nftCollection: UITableView = {
        let collection = UITableView()
        collection.register(CatalogTableViewCell.self)
        collection.register(CatalogTableFooterView.self)
        collection.separatorStyle = .none
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = CatalogViewControllerViewModel()
        nftCollection.dataSource = self
        nftCollection.delegate = self
        setUp()
        ProgressHUD.show()
        bind()
        viewModel?.getCollections()
    }

    // MARK: - Private Methods

    private func bind() {

        viewModel?.onChange = { [weak self] in
            self?.nftCollection.reloadData()
            ProgressHUD.dismiss()
        }
    }

    private func setUp() {
        view.backgroundColor = .systemBackground
        [burgerButton, nftCollection].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            burgerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            burgerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            burgerButton.widthAnchor.constraint(equalToConstant: 42),
            burgerButton.heightAnchor.constraint(equalToConstant: 42),
            nftCollection.topAnchor.constraint(equalTo: burgerButton.bottomAnchor, constant: 20),
            nftCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func filterByName() {
        viewModel?.collectionsFilterByName()
        self.nftCollection.reloadData()
    }

    private func filterByNumber() {
        viewModel?.collectionsFilterByNumber()
        self.nftCollection.reloadData()
    }

    @objc private func didPressBurgerButton() {

        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString("Catalog.sort", comment: ""),
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Catalog.sort.byName", comment: ""),
            style: .default,
            handler: {_ in
                self.filterByName()
            }
        ))
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Catalog.sort.byNftNumber", comment: ""),
            style: .default,
            handler: {_ in
                self.filterByNumber()
            }
        ))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}

extension CatalogViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.collectionsNumber() ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as CatalogTableViewCell
        let collection = viewModel?.collections[indexPath.section]
        if let urlEndpoint = collection?.cover.components(separatedBy: "/").last {
            cell.configure(for: urlEndpoint)
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension CatalogViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = viewModel?.collections[indexPath.section]
        let viewController = CollectionViewController()

        guard let id = collection?.id else { return }
        viewController.viewModel = CollectionViewModel()
        viewController.viewModel?.getCollectionViewData(collectionId: id)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let collection = viewModel?.collections[section]
        guard let name = collection?.name,
              let count = collection?.nfts.count else { return UIView() }
        let footerString = "\(name) (\(count))"

        let footerView = tableView.dequeueReusableHeaderFooterView() as CatalogTableFooterView
        footerView.configure(labelText: footerString)
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
}
