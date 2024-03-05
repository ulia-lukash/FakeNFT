//
//  PaymentCollectionCell.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 22.02.2024.
//

import Kingfisher
import UIKit

final class PaymentCollectionCell: UICollectionViewCell {
    
    // MARK: - Identifier
    
    static let cellIdentifier = "PaymentCollectionCell"
    
    // MARK: - Public Properties
    
    override var isSelected: Bool {
        didSet {
            updateSelectionStyle()
        }
    }
    
    var currencyId: String?
    var currencyName: String?
    
    // MARK: - UI Elements
    
    private lazy var currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blackUniversal
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var paymentSystemLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .greenUniversal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellAppearance()
        configureSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setupCell(with model: CurrenciesModel) {
        guard let imageUrl = URL(string: model.image) else {
            // Handle invalid URL
            return
        }
        
        currencyImageView.kf.indicatorType = .activity
        currencyImageView.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "Placeholder"),
            options: [.transition(.fade(1))]) { result in
                switch result {
                case .success:
                    // Image loaded successfully
                    break
                case .failure(let error):
                    print("Error loading image: \(error.localizedDescription)")
                }
        }
        
        paymentSystemLabel.text = model.title
        currencyNameLabel.text = model.name
        currencyId = model.id
        currencyName = model.name
    }
    
    // MARK: - Private Methods
    
    private func configureSubviews() {
        addSubview(currencyImageView)
        addSubview(paymentSystemLabel)
        addSubview(currencyNameLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            currencyImageView.heightAnchor.constraint(equalToConstant: 36),
            currencyImageView.widthAnchor.constraint(equalToConstant: 36),
            currencyImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            currencyImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            
            paymentSystemLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
            paymentSystemLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            paymentSystemLabel.heightAnchor.constraint(equalToConstant: 18),
            
            currencyNameLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
            currencyNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            currencyNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func setupCellAppearance() {
        backgroundColor = .segmentInactive
        layer.cornerRadius = 12
        updateSelectionStyle()
    }
    
    private func updateSelectionStyle() {
        layer.borderWidth = isSelected ? 1 : 0
        layer.borderColor = isSelected ? UIColor.segmentActive.cgColor : UIColor.clear.cgColor
    }
}
