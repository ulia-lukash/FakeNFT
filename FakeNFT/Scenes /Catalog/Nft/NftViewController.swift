//
//  NftViewController.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 25.02.2024.
//

import Foundation
import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getNft(withId: nftId)
        bind()
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
//            self.setLabelValues()
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
    }
    
    private func setUpScrollView() {
        [imagesCollection].forEach {
            scrollViewContent.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollViewContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollViewContent.heightAnchor.constraint(equalToConstant: 1400)
        ])
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: false)
    }
    
    @objc private func likeButtonTapped() {
        viewModel.didTapLikeFor(nft: nftId)
        
        likeButton.tintColor = likeButton.tintColor == .redUniversal ? .whiteUniversal : .redUniversal
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
            guard let nft = viewModel.nft else { return UICollectionViewCell() }
            let isLiked = viewModel.isLiked(nft: nftId)
            let isInCart = viewModel.isInCart(nft: nftId)
            cell.configure(nft: nft, isLiked: isLiked, isInCart: isInCart)
            return cell
        }
    }
    
}

extension NftViewController: UICollectionViewDelegate {
    
}
