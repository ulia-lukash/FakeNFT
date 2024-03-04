//
//  NftViewController.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 04.03.2024.
//

import UIKit
import ProgressHUD
import SafariServices

final class NftViewController: UIViewController, ErrorView, LoadingView {

   let viewModel: NftViewModelProtocol
   let nftId: String

   lazy var activityIndicator: UIActivityIndicatorView = {
       let activityIndicator = UIActivityIndicatorView()
       activityIndicator.color = .blackUniversal

       return activityIndicator
   }()
   private lazy var scrollView = UIScrollView()
   private lazy var scrollViewContent = UIView()
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
       collectionView.isUserInteractionEnabled = true
       collectionView.allowsSelection = true
       collectionView.showsHorizontalScrollIndicator = false
       collectionView.isPagingEnabled = true
       collectionView.backgroundColor = .clear
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
       tableView.rowHeight = 72
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
       button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
       let title = NSLocalizedString("Go to seller's website", comment: "")
       button.setTitle(title, for: .normal)
       button.setTitleColor(.segmentActive, for: .normal)
       button.layer.borderColor = UIColor.segmentActive.cgColor
       button.addTarget(self, action: #selector(goToSellerWebsite), for: .touchUpInside)
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
       collectionView.backgroundColor = .clear
       return collectionView
   }()

   override func viewDidLoad() {
       super.viewDidLoad()
       navigationItem.rightBarButtonItem = likeButton
       self.navigationController?.navigationBar.tintColor = .segmentActive
       self.navigationController?.navigationBar.topItem?.title = ""
       view.backgroundColor = .whiteModeThemes
       setUp()
       viewModel.delegate = self
       bind()
       viewModel.setStateLoading()

   }

   init(viewModel: NftViewModelProtocol, nftId: String) {
       self.viewModel = viewModel
       self.nftId = nftId
       super.init(nibName: nil, bundle: nil)
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

   private func bind() {
       guard let viewModel = viewModel as? NftViewModel else { return }
       viewModel.$state.bind { [weak self] state in
           guard let self else { return }
           switch state {
           case .initial:
               assertionFailure("Cannot move to initial state")
           case .loading:
               self.showLoading()
               viewModel.loadNft(withId: nftId)
           case .update:
               self.showLoading()
               self.currenciesTable.reloadData()
               self.hideLoading()
           case .failed(let error):
               self.hideLoading()
               let errorModel = viewModel.makeErrorModel(error: error)
               self.showError(errorModel)
           case .data:
               self.setLikeButtonState()
               self.setCartButtonState()
               self.setLabels()
               self.hideLoading()
               self.pageControl.numberOfItems = viewModel.nft?.images.count ?? 0
               self.imagesCollection.reloadData()
           }
       }
   }

   private func setLabels() {
       guard let nft = viewModel.nft else { return }

       nameLabel.text = nft.name
       ratingView.setRating(with: nft.rating)
       setCartButtonState()
       setLikeButtonState()
       /* Нет в nft указателя на его коллекцию.
        Подтаскивать все коллекции и искать, откуда
        эта конкретная штука - нецелесообразно.
        Да, можно передавать из коллекции, но мы не всегда открываем nft из его коллекции.
        */
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
       [scrollView, activityIndicator].forEach {
           view.addSubview($0)
           $0.backgroundColor = .clear
           $0.translatesAutoresizingMaskIntoConstraints = false
       }
       scrollView.constraintEdges(to: view)
       activityIndicator.constraintCenters(to: view)
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

   @objc private func goToSellerWebsite() {
       guard let urlString = viewModel.nft?.author, let url = URL(string: urlString) else { return }
       let viewController = SFSafariViewController(url: url)
       present(viewController, animated: true)
   }
}

extension NftViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       if collectionView == imagesCollection {
           return viewModel.nft?.images.count ?? 0
       } else {
           return viewModel.nfts.count
       }
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if collectionView == imagesCollection {
           let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as NftImageCollectionViewCell
           guard let urlstrins = viewModel.nft?.images else { return UICollectionViewCell() }
           let urlString = urlstrins[indexPath.row]
           let url = URL(string: urlString)!
           cell.configure(with: url, shouldRoundCorners: true)

           return cell
       } else {
           let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as NftCollectionCell
           let nft = viewModel.nfts[indexPath.row]
           let isLiked = viewModel.isLiked(nft: nft.id)
           let isInCart = viewModel.isInCart(nft: nft.id)
           cell.delegate = self
           cell.configure(nft: nft, isLiked: isLiked, isInCart: isInCart)
           return cell
       }
   }

}

extension NftViewController: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       if collectionView == nftsCollection {
           let nfts = viewModel.nfts
           if indexPath.row + 1 == nfts.count {
               viewModel.fetchMoreNfts()
           }
       } else {
           pageControl.selectedItem = indexPath.row
       }
   }
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

       if collectionView == nftsCollection {
           let nft = viewModel.nfts[indexPath.row]
           let viewController = NftViewController(
               viewModel: NftViewModel(
                   currencyService: CurrenciesServiceImpl(
                       networkClient: DefaultNetworkClient(),
                       storage: CurrenciesStorageImpl()),
                   nftService: NftServiceImpl(
                       networkClient: DefaultNetworkClient(),
                       storage: NftStorageImpl()),
                   profileService: ProfileServiceImpl(
                       networkClient: DefaultNetworkClient(),
                       storage: ProfileStorageImpl()),
                   orderService: OrderServiceImpl(
                       networkClient: DefaultNetworkClient(),
                       storage: OrderStorageImpl())),
               nftId: nft.id)
           self.navigationController?.pushViewController(viewController, animated: true)
       } else if collectionView == imagesCollection {
           guard let nft = viewModel.nft else { return }
           let urls = nft.images.map {URL(string: $0)!}
           let viewController = NftDetailViewController(urls: urls)
           self.present(viewController, animated: true)
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
}

extension NftViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       viewModel.currencies?.count ?? 0
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell() as CurrenciesTableCell
       if let currency = viewModel.currencies?[indexPath.row] {
           cell.configure(forCurrency: currency)
       }
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
   func didTapLikeFor(nft id: String) {
       viewModel.didTapLikeFor(nft: id)
   }

   func didTapCartFor(nft id: String) {
       viewModel.didTapCartFor(nft: id)
   }

   func reloadTable() {
       nftsCollection.reloadData()
   }
}
