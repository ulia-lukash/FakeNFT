//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 13.02.2024.
//

import Foundation
import UIKit
import Kingfisher

final class CollectionViewController: UIViewController {

    private let mockCollectionObject = NftCollection(
        createdAt: "2023-04-20T02:22:27Z",
        name: "Blue",
        cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/ÐžÐ±Ð»Ð¾Ð¶ÐºÐ¸_ÐºÐ¾Ð»Ð»ÐµÐºÑ†Ð¸Ð¹/Blue.png",
        nfts: ["22", "23", "24", "25", "26"],
        description: "A collection of virtual trading cards featuring popular characters from movies and TV shows.",
        author: "9",
        id: "2")
    private let widthParameters = CollectionParameters(cellsNumber: 3, leftInset: 0, rightInset: 0, interCellSpacing: 10)
    private lazy var backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor.segmentActive
        label.text = mockCollectionObject.name
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.segmentActive
//        label.text = NSLocalizedString("Collection's author", comment: "")
        let attributedString = NSMutableAttributedString(string: NSLocalizedString("Collection author:", comment: "") + " John Doe")
        let linkLength = attributedString.length - 19
        attributedString.addAttribute(.link, value: "https://practicum.yandex.ru/algorithms/", range: NSRange(location: 17, length: linkLength))
        label.attributedText = attributedString
        return label
    }()

    private lazy var desriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.segmentActive
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = mockCollectionObject.description
        return label
    }()

    private lazy var nftCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.scrollDirection = .vertical
        collection.collectionViewLayout = flowLayout
        collection.register(NftCollectionCell.self)
        collection.backgroundColor = .clear
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        nftCollection.dataSource = self
        nftCollection.delegate = self
        setUp()
        setCoverOrCollection(withName: mockCollectionObject.name)
    }

    private func setUp() {
        backButtonItem.tintColor = UIColor.segmentActive
        navigationItem.leftBarButtonItem = backButtonItem
        view.backgroundColor = UIColor.whiteModeThemes
        [coverImageView, nameLabel, authorLabel, desriptionLabel, nftCollection].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: view.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 325),
            nameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),
            authorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            authorLabel.heightAnchor.constraint(equalToConstant: 28),
            desriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor),
            desriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            desriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollection.topAnchor.constraint(equalTo: desriptionLabel.bottomAnchor, constant: 20),
            nftCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setCoverOrCollection(withName name: String) {
        let urlString = "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/" + name + ".png"
        let url = URL(string: urlString)
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: coverImageView.bounds.width, height: 325), mode: .aspectFill)
        coverImageView.kf.indicatorType = .activity
        coverImageView.kf.setImage(
            with: url,
            options: [
                .processor(processor)
            ]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
    }

    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        15
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as NftCollectionCell
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - widthParameters.widthInsets
        let cellWidth = availableWidth / CGFloat(widthParameters.cellsNumber)
        return CGSize(width: cellWidth, height: 192)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: widthParameters.leftInset, bottom: 4, right: widthParameters.rightInset)
    }

}
