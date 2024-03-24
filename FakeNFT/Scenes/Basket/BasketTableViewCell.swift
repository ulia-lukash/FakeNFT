//
//  BasketTableViewCell.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 10.02.2024.
//

import Kingfisher
import UIKit

protocol BasketTableViewCellDelegate: AnyObject {
    func deleteButtonClicked(image: UIImage, id: String)
}

final class BasketTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "BasketTableViewCell"
    
    weak var delegate: BasketTableViewCellDelegate?
    
    private var idNftToDelete: String?
    
    private let imageNFT: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameNFTLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.black.color
        label.font = .SF17bold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingView = RatingView()
    
    private let stubNFTLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.black.color
        label.text = ConstLocalizable.basketPrice
        label.font = .SF13regular
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityNFTLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.black.color
        label.font = .SF17bold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deleteNFTButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "tabler_trash-x"), for: .normal)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        button.tintColor = Asset.Colors.black.color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with nft: Nft) {
        setupNftData(nft)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        [imageNFT, nameNFTLabel, ratingView, stubNFTLabel, quantityNFTLabel, deleteNFTButton].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageNFT.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageNFT.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageNFT.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            imageNFT.widthAnchor.constraint(equalToConstant: 108),
            imageNFT.heightAnchor.constraint(equalTo: imageNFT.widthAnchor),
            
            nameNFTLabel.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            nameNFTLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameNFTLabel.heightAnchor.constraint(equalToConstant: 22),
            
            ratingView.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            ratingView.topAnchor.constraint(equalTo: nameNFTLabel.bottomAnchor, constant: 4),
            ratingView.widthAnchor.constraint(equalToConstant: 68),
            ratingView.heightAnchor.constraint(equalToConstant: 15),
            
            stubNFTLabel.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            stubNFTLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 12),
            stubNFTLabel.heightAnchor.constraint(equalToConstant: 18),
            
            quantityNFTLabel.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            quantityNFTLabel.topAnchor.constraint(equalTo: stubNFTLabel.bottomAnchor, constant: 2),
            
            deleteNFTButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteNFTButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteNFTButton.widthAnchor.constraint(equalToConstant: 40),
            deleteNFTButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupNftData(_ nft: Nft) {
        let url = URL(string: nft.images.first!)
        imageNFT.kf.setImage(with: url, placeholder: UIImage(named: "Placeholder"), options: [.transition(.fade(1))])
        nameNFTLabel.text = nft.name
        let formattedPrice = String(format: "%.2f", nft.price).replacingOccurrences(of: ".", with: ",")
        quantityNFTLabel.text = "\(formattedPrice) ETH"
        idNftToDelete = nft.id
        ratingView.rating = nft.rating > 5 ? 5 : nft.rating
    }
    
    @objc private func didTapDeleteButton() {
        guard let image = imageNFT.image else { return }
        guard let id = idNftToDelete else { return }
        delegate?.deleteButtonClicked(image: image, id: id)
    }
}
