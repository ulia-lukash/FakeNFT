//
//  NftViewController.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 25.02.2024.
//

import Foundation
import UIKit
import ProgressHUD

final class NftViewController: UIViewController {
    let viewModel: NftViewModelProtocol
    let nftId: UUID
    
    private lazy var scrollView = UIScrollView()
    private lazy var scrollViewContent = UIView()
    
    private lazy var backButton: UIBarButtonItem = {
        let image = UIImage(systemName: "chevron.left")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        button.tintColor = .segmentActive
        return button
    }()
    
    private lazy var likeButton: UIBarButtonItem = {
        let image = UIImage(systemName: "heart.fill")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(likeButtonTapped))
        return button
    }()
    private lazy var imagesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NftImageCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private lazy var pageControl = LinePageControl()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var ratingView = StarRatingView()
    
    private lazy var collectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var price: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = NSLocalizedString("Price", comment: "")
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    private lazy var currenciesTable: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.register(CurrenciesTableCell.self)
        tableView.separatorColor = .clear
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 12
        tableView.backgroundColor = .segmentInactive
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var goToSellerButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.backgroundColor = .clear
        button.tintColor = .segmentActive
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        let title = NSLocalizedString("Go to seller's website", comment: "")
        button.setTitle(title, for: .normal)
        button.setTitleColor(.segmentActive, for: .normal)
        return button
    }()
    
    private lazy var nftsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 108, height: 192)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        collectionView.register(NftCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.show()
        viewModel.delegate = self
        bind()
        viewModel.getNft(withId: nftId)
        setUp()
    }
    
    init(viewModel: NftViewModelProtocol, nftId: UUID) {
        self.viewModel = viewModel
        self.nftId = nftId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        self.viewModel.onChange = { [weak self] in
            guard let nft = self?.viewModel.nft else { return }
            self?.pageControl.numberOfItems = nft.images.count
            self?.setLabels()
            self?.imagesCollection.reloadData()
            self?.currenciesTable.reloadData()
            ProgressHUD.dismiss()
        }
    }
    
    private func setLabels() {
        
        setCartButtonState()
        setLikeButtonState()
        guard let nft = viewModel.nft else { return }
        
        nameLabel.text = nft.name
        ratingView.setRating(with: nft.rating)
/* Нет в nft указателя на его коллекцию.
Подтаскивать все коллекции и искать, откуда
эта конкретная штука - нецелесообразно.
Ждем когда доведут до ума бэк */
        collectionNameLabel.text = "Peach"
        
        priceLabel.text = "\(nft.price) ETH"
    }
    
    private func setLikeButtonState() {
        likeButton.tintColor = viewModel.isLiked(nft: nftId) ? .redUniversal : .whiteUniversal
    }
    
    private func setCartButtonState() {
        if viewModel.isInCart(nft: nftId) {
            addToCartButton.backgroundColor = .segmentInactive
            addToCartButton.setTitleColor(.segmentActive, for: .normal)
            let title = NSLocalizedString("Go to cart", comment: "")
            addToCartButton.setTitle(title, for: .normal)
            addToCartButton.addTarget(self, action: #selector(goToCart), for: .touchUpInside)
        } else {
            addToCartButton.backgroundColor = .segmentActive
            addToCartButton.setTitleColor(.whiteModeThemes, for: .normal)
            let title = NSLocalizedString("Add to cart", comment: "")
            addToCartButton.setTitle(title, for: .normal)
            addToCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        }
    }
    
    private func setUp() {
        navigationItem.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = likeButton
        view.backgroundColor = .whiteModeThemes
        view.addSubview(scrollView)
        scrollView.constraintEdges(to: view)
        scrollView.addSubview(scrollViewContent)
        scrollViewContent.constraintEdges(to: scrollView)
        setUpScrollView()
        setConstraints()
    }
    
    private func setUpScrollView() {
        [imagesCollection, pageControl, nameLabel, ratingView, collectionNameLabel, price, priceLabel, addToCartButton, currenciesTable, goToSellerButton, nftsCollection].forEach {
            scrollViewContent.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollViewContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollViewContent.heightAnchor.constraint(equalToConstant: 1400),
            
            imagesCollection.topAnchor.constraint(equalTo: scrollViewContent.topAnchor, constant: -100),
            imagesCollection.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor),
            imagesCollection.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor),
            imagesCollection.heightAnchor.constraint(equalTo: scrollViewContent.widthAnchor),
            
            pageControl.topAnchor.constraint(equalTo: imagesCollection.bottomAnchor, constant: 12),
            pageControl.heightAnchor.constraint(equalToConstant: 4),
            pageControl.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 16),
            pageControl.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 28),
            nameLabel.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 16),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),
            
            ratingView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            ratingView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            
            collectionNameLabel.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -16),
            collectionNameLabel.heightAnchor.constraint(equalToConstant: 22),
            collectionNameLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            
            price.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 16),
            price.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            price.heightAnchor.constraint(equalToConstant: 20),
            
            priceLabel.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 16),
            priceLabel.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 2),
            priceLabel.heightAnchor.constraint(equalToConstant: 22),
            
            addToCartButton.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -16),
            addToCartButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            addToCartButton.heightAnchor.constraint(equalToConstant: 44),
            addToCartButton.widthAnchor.constraint(equalToConstant: 240),
            
            currenciesTable.topAnchor.constraint(equalTo: addToCartButton.bottomAnchor, constant: 24),
            currenciesTable.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 16),
            currenciesTable.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -16),
            currenciesTable.heightAnchor.constraint(equalToConstant: 576),
            goToSellerButton.topAnchor.constraint(equalTo: currenciesTable.bottomAnchor, constant: 24),
            goToSellerButton.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 16),
            goToSellerButton.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -16),
            goToSellerButton.heightAnchor.constraint(equalToConstant: 40),
            
            nftsCollection.topAnchor.constraint(equalTo: goToSellerButton.bottomAnchor, constant: 36),
            nftsCollection.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor),
            nftsCollection.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor),
            nftsCollection.heightAnchor.constraint(equalToConstant: 192)
            
        ])
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: false)
    }
    
    @objc private func likeButtonTapped() {
        viewModel.didTapLikeFor(nft: nftId)
        
        likeButton.tintColor = likeButton.tintColor == .redUniversal ? .whiteUniversal : .redUniversal
    }
    
    @objc private func addToCart() {
        viewModel.didTapCartFor(nft: nftId)
        addToCartButton.backgroundColor = .segmentInactive
        addToCartButton.setTitleColor(.segmentActive, for: .normal)
        let title = NSLocalizedString("Go to cart", comment: "")
        addToCartButton.setTitle(title, for: .normal)
        addToCartButton.addTarget(self, action: #selector(goToCart), for: .touchUpInside)
    }
    
    @objc private func goToCart() {
//        TODO: make segue to cart page
    }
}

extension NftViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imagesCollection {
            return viewModel.nft?.images.count ?? 0
        } else {
            return viewModel.nfts?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imagesCollection {
            let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as NftImageCollectionViewCell
            guard let urls = viewModel.nft?.images else { return UICollectionViewCell() }
            let url = urls[indexPath.row]
            cell.configure(with: url)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as NftCollectionCell
            guard let nft = viewModel.nfts?[indexPath.row] else { return UICollectionViewCell() }
            let isLiked = viewModel.isLiked(nft: nftId)
            let isInCart = viewModel.isInCart(nft: nftId)
            cell.configure(nft: nft, isLiked: isLiked, isInCart: isInCart)
            return cell
        }
    }
    
}

extension NftViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == nftsCollection {
            guard let nfts = viewModel.nfts else { return }
            if indexPath.row + 1 == nfts.count {
                viewModel.fetchMoreNfts()
            }
        }
    }
}

extension NftViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imagesCollection {
            return collectionView.bounds.size
        } else {
            return CGSize(width: 108, height: 192)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let selectedItem = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.selectedItem = selectedItem
    }
}

extension NftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as CurrenciesTableCell
        let currency = viewModel.currencies[indexPath.row]
        cell.configure(forCurrency: currency)
        return cell
    }
    
}

extension NftViewController: NftViewModelDelegateProtocol {
    func updateCollectionView(oldCount: Int, newCount: Int) {
        if oldCount != newCount {
            nftsCollection.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { index in
                    IndexPath(row: index, section: 0)
                }
                nftsCollection.insertItems(at: indexPaths)
            } completion: { _ in }
        }
    }
}

extension NftViewController: NftCollectionCellDelegate {
    func didTapLikeFor(nft id: UUID) {
        viewModel.didTapLikeFor(nft: id)
    }
    
    func didTapCartFor(nft id: UUID) {
        viewModel.didTapCartFor(nft: id)
    }
    
    func reloadTable() {
        nftsCollection.reloadData()
    }
}
