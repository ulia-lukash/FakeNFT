//
//  BasketSuccessView.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 22.02.2024.
//

import UIKit

protocol BasketSuccessViewDelegate: AnyObject {
    func backToBasket()
}

final class BasketSuccessView: UIView {
    
    // MARK: - Delegate
    
    weak var delegate: BasketSuccessViewDelegate?
    
    // MARK: - UI Elements
    
    private lazy var stubCardImage: UIImageView = {
        let image = UIImage(named: "successfulPurchase")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stubCardLabel: UILabel = {
        let label = UILabel()
        label.text = ConstLocalizable.basketSuccess
        label.font = .SF22bold
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = Asset.Colors.black.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stubCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Asset.Colors.black.color
        button.tintColor = Asset.Colors.white.color
        button.setTitle(ConstLocalizable.basketReturnCatalog, for: .normal)
        button.titleLabel?.font = .SF17bold
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapBackCatalog), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        addSubview(stubCardImage)
        addSubview(stubCardLabel)
        addSubview(stubCardButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stubCardImage.heightAnchor.constraint(equalToConstant: 278),
            stubCardImage.widthAnchor.constraint(equalToConstant: 278),
            stubCardImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            stubCardImage.topAnchor.constraint(equalTo: topAnchor, constant: 196),
            
            stubCardLabel.topAnchor.constraint(equalTo: stubCardImage.bottomAnchor, constant: 20),
            stubCardLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            stubCardButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            stubCardButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stubCardButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stubCardButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Objc Methods
    
    @objc private func didTapBackCatalog() {
        delegate?.backToBasket()
    }
}
