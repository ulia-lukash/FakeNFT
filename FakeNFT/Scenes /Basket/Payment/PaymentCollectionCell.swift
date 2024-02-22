//
//  PaymentCollectionCell.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 22.02.2024.
//

import Kingfisher
import UIKit

final class PaymentCollectionCell: UICollectionViewCell {
    
    //MARK: - Identifer:
    
    static let identifier = "PaymentCollectionCell"
    
    // MARK: - Public properties:
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = isSelected ? 1 : 0
            self.layer.borderColor = isSelected ? UIColor.blackUniversal.cgColor : UIColor.clear.cgColor
        }
    }
    
    //MARK: - UI:
    
    private lazy var currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.blackUniversal
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var paymentSystemLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currencyNameLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.greenUniversal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.segmentInactive
        layer.cornerRadius = 12
        configureCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func cellSettings(for model: CurrenciesModel) {
        let url = URL(string: model.image)
        currencyImageView.kf.indicatorType = .activity
        currencyImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Placeholder"),
            options: [.transition(.fade(1))])
        paymentSystemLabel.text = model.title
        currencyNameLabel.text = model.name
    }
    
    // MARK: - Private Methods
    
    private func configureCell() {
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
            currencyNameLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
}
