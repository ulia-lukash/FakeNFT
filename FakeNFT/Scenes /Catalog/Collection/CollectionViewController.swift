//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 13.02.2024.
//

import Foundation
import UIKit
import Kingfisher
import ProgressHUD

final class CollectionViewController: UIViewController {

    let viewModel = CollectionViewModel()

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
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.segmentActive
        return label
    }()

    private lazy var authorNameLabel: UIButton = {
        let button = UIButton()
        button.setTitleColor(.blueUniversal, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        button.addTarget(self, action: #selector(didTapAuthorName), for: .touchUpInside)
        return button
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.segmentActive
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
        ProgressHUD.show()
        bind()
        nftCollection.dataSource = self
        nftCollection.delegate = self
        setUp()
    }

    private func bind() {

        viewModel.onChange = { [weak self] in
            self?.configure()
            ProgressHUD.dismiss()
        }

    }

    private func configure() {
        setCoverOfCollection(withName: viewModel.collection?.name ?? "Collection name")
        setLabels()
    }
    private func setUp() {
        backButtonItem.tintColor = UIColor.segmentActive
        navigationItem.leftBarButtonItem = backButtonItem
        view.backgroundColor = UIColor.whiteModeThemes
        [coverImageView, nameLabel, authorLabel, authorNameLabel, descriptionLabel, nftCollection].forEach {
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
            authorLabel.widthAnchor.constraint(equalToConstant: 112),
            authorNameLabel.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 4),
            authorNameLabel.heightAnchor.constraint(equalToConstant: 28),
            authorNameLabel.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            authorLabel.heightAnchor.constraint(equalToConstant: 28),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollection.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            nftCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setCoverOfCollection(withName name: String) {
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

    private func setLabels() {
        guard let collection = viewModel.collection else { return }
        nameLabel.text = collection.name
        descriptionLabel.text = collection.description
        guard let author = viewModel.author else { return }
        authorLabel.text = NSLocalizedString("Collection author:", comment: "")
        authorNameLabel.setTitle(author.name, for: .normal)
    }

    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc private func didTapAuthorName() {
        let vc = AuthorViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.collection?.nfts.count ?? 0
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
