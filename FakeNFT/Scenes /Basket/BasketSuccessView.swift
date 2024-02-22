//
//  BasketSuccessView.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 22.02.2024.
//

import UIKit

final class BasketSuccessView: UIView {
    
    //MARK: - Delegate
    //MARK: - UI
    
    private lazy var innerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stubCardImage: UIImageView = {
        let image = UIImage(named: "successfulPurchase")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stubCardLabel: UILabel = {
        var label = UILabel()
        label.text = "Успех! Оплата прошла, \nпоздравляем с покупкой!"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor.segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stubCardButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = UIColor.segmentActive
        button.tintColor = UIColor.whiteModeThemes
        button.setTitle("Вернуться в каталог", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapBackCatalog), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Life Cycle
    
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
    
    //MARK: - Public Properties
    
    //MARK: - Private Properties
    
    private func setupView() {
        addSubview(innerView)
        innerView.addSubview(stubCardImage)
        innerView.addSubview(stubCardLabel)
        innerView.addSubview(stubCardButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            innerView.topAnchor.constraint(equalTo: self.topAnchor),
            innerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            innerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            innerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            stubCardImage.heightAnchor.constraint(equalToConstant: 278),
            stubCardImage.widthAnchor.constraint(equalToConstant: 278),
            stubCardImage.centerXAnchor.constraint(equalTo: innerView.centerXAnchor),
            stubCardImage.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 196),
            
            stubCardLabel.topAnchor.constraint(equalTo: stubCardImage.bottomAnchor, constant: 20),
            stubCardLabel.centerXAnchor.constraint(equalTo: innerView.centerXAnchor),
            
            stubCardButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            stubCardButton.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 16),
            stubCardButton.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -16),
            stubCardButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc private func didTapBackCatalog() {
        //TODO
    }
}


