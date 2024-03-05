//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 11.02.2024.
//

import UIKit

final class CatalogViewController: UIViewController, LoadingView, ErrorView {

    private let viewModel: CatalogViewModelProtocol

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .blackUniversal

        return activityIndicator
    }()

    private lazy var burgerButton: UIBarButtonItem = {
        let image = UIImage(systemName: "text.justify.leading")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didPressBurgerButton))
        button.tintColor = UIColor.segmentActive
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

        nftCollection.dataSource = self
        nftCollection.delegate = self
        setUp()
        bind()
        viewModel.setStateLoading()
    }

    init(viewModel: CatalogViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func bind() {

        guard let viewModel = viewModel as? CatalogViewModel else { return }
        viewModel.$state.bind { [weak self] state in
            guard let self else { return }
            switch state {
            case .initial:
                assertionFailure("Cannot move to initial state")
            case .loading:
                self.showLoading()
                viewModel.loadCollections()
            case .update:
                self.showLoading()
                self.nftCollection.reloadData()
            case .failed(let error):
                self.hideLoading()
                let errorModel = viewModel.makeErrorModel(error: error)
                self.showError(errorModel)
            case .data:
                self.hideLoading()
                self.nftCollection.reloadData()
            }
        }
    }

    private func setUp() {
        view.backgroundColor = .systemBackground
        [nftCollection, activityIndicator].forEach {
            view.addSubview($0)
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        setConstraints()
        self.navigationItem.rightBarButtonItem = burgerButton
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([

            nftCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        activityIndicator.constraintCenters(to: view)
    }

    private func filterByName() {
        viewModel.collectionsFilterByName()
        self.nftCollection.reloadData()
    }

    private func filterByNumber() {
        viewModel.collectionsFilterByNumber()
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
        viewModel.collectionsNumber()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as CatalogTableViewCell
        let collection = viewModel.collections?[indexPath.section]
        if let urlEndpoint = collection?.cover.components(separatedBy: "/").last {
            cell.configure(for: urlEndpoint)
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension CatalogViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = viewModel.collections?[indexPath.section]
        guard let id = collection?.id else { return }
        let viewModel = CollectionViewModel(
            collectionService: CollectionServiceImpl(
                networkClient: DefaultNetworkClient(),
                storage: CollectionStorageImpl()),
            nftService: NftServiceImpl(
                networkClient: DefaultNetworkClient(),
                storage: NftStorageImpl()),
            profileService: ProfileServiceImpl(
                networkClient: DefaultNetworkClient(),
                storage: ProfileStorageImpl()),
            orderService: OrderServiceImpl(
                networkClient: DefaultNetworkClient(),
                storage: OrderStorageImpl()))

        let viewController = CollectionViewController(viewModel: viewModel, collectionId: id)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let collection = viewModel.collections?[section]
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
