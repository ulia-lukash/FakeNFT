//
//  NftDetailViewController.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 04.03.2024.
//

import UIKit
import Kingfisher

final class NftDetailViewController: UIViewController {

    let urls: [URL]
    private lazy var collectionView: UICollectionView = {
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

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .closeButton
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()

    private lazy var pageControl = LinePageControl()
    internal lazy var activityIndicator = UIActivityIndicatorView()

    // MARK: - Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.numberOfItems = urls.count
        view.backgroundColor = .white
        setupLayout()
    }

    init(urls: [URL]) {
        self.urls = urls
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - private functions

    private func setupLayout() {
        collectionView.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: collectionView)

        view.addSubview(collectionView)
        collectionView.constraintEdges(to: view)

        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: collectionView.safeAreaLayoutGuide.bottomAnchor)
        ])

        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc
    private func close() {
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension NftDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        urls.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NftImageCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)

        let url = urls[indexPath.row]
        cell.configure(with: url, shouldRoundCorners: false)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NftDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let selectedItem = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.selectedItem = selectedItem
    }
}
