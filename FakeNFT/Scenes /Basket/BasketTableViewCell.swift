//
//  BasketTableViewCell.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 10.02.2024.
//

import UIKit

final class BasketTableViewCell: UITableViewCell {
    
    // MARK: - Identifier
    
    static let identifier = "BasketTableViewCell"
    
    //MARK: - UI
    
    private lazy var imageNFT: UIImageView = {
        let image = UIImage(named: "cardNFTStub")
        let imageView = UIImageView()
        imageView.image = image
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameNFTLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "Test"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingNFTImage: UIImageView = {
        let image = UIImage(named: "raitingStub")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stubNFTLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Цена"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var quantityNFTLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "1,23 ETH"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteNFTButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "tabler_trash-x"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        backgroundColor = .systemBackground
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods:
    
    private func setupView() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(imageNFT)
        contentView.addSubview(nameNFTLabel)
        contentView.addSubview(ratingNFTImage)
        contentView.addSubview(stubNFTLabel)
        contentView.addSubview(quantityNFTLabel)
        contentView.addSubview(deleteNFTButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 140),
            
            imageNFT.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageNFT.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageNFT.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            imageNFT.heightAnchor.constraint(equalToConstant: 108),
            imageNFT.widthAnchor.constraint(equalToConstant: 108),
            
            nameNFTLabel.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            nameNFTLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),

            ratingNFTImage.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            ratingNFTImage.topAnchor.constraint(equalTo: nameNFTLabel.bottomAnchor, constant: 4),
            ratingNFTImage.heightAnchor.constraint(equalToConstant: 12),
            ratingNFTImage.widthAnchor.constraint(equalToConstant: 68),
         
            stubNFTLabel.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            stubNFTLabel.topAnchor.constraint(equalTo: ratingNFTImage.bottomAnchor, constant: 12),
            
            quantityNFTLabel.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            quantityNFTLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            deleteNFTButton.heightAnchor.constraint(equalToConstant: 40),
            deleteNFTButton.widthAnchor.constraint(equalToConstant: 40),
            deleteNFTButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteNFTButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50)
        ])
    }
    
}
