//
//  BasketDeleteCardView.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 12.02.2024.
//

import UIKit

protocol BasketDeleteCardViewDelegate: AnyObject {
    func backButtonClicked()
    func didTapDeleteCardButton(index: String)
}

final class BasketDeleteCardView: UIView {
    
    //MARK: - Delegate
    
    weak var delegate: BasketDeleteCardViewDelegate?
    
    // MARK: - Private properties:
    
    private var idNftToDelete = ""
    
    //MARK: - UI
    
    private lazy var innerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deleteCardImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var deleteCardLabel: UILabel = {
        var label = UILabel()
        label.text = "Вы уверены, что хотите \nудалить объект из корзины?"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor.segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteCardButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = UIColor.segmentActive
        button.tintColor = UIColor.redUniversal
        button.setTitle("Удалить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapDeleteCardButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backCardButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = UIColor.segmentActive
        button.tintColor = UIColor.whiteModeThemes
        button.setTitle("Вернуться", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapbackCardButton), for: .touchUpInside)
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
    
    func configureView(image: UIImage, idNftToDelete: String) {
        deleteCardImage.image = image
        self.idNftToDelete = idNftToDelete
    }
    
    //MARK: - Private Properties
    
    private func setupView() {
        addSubview(innerView)
        innerView.addSubview(deleteCardImage)
        innerView.addSubview(deleteCardLabel)
        innerView.addSubview(deleteCardButton)
        innerView.addSubview(backCardButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            innerView.topAnchor.constraint(equalTo: self.topAnchor),
            innerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            innerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            innerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            deleteCardImage.heightAnchor.constraint(equalToConstant: 108),
            deleteCardImage.widthAnchor.constraint(equalToConstant: 108),
            deleteCardImage.centerXAnchor.constraint(equalTo: innerView.centerXAnchor),
            deleteCardImage.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 244),
            
            deleteCardLabel.topAnchor.constraint(equalTo: deleteCardImage.bottomAnchor, constant: 12),
            deleteCardLabel.centerXAnchor.constraint(equalTo: innerView.centerXAnchor),
            
            deleteCardButton.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 56),
            deleteCardButton.topAnchor.constraint(equalTo: deleteCardLabel.bottomAnchor, constant: 20),
            deleteCardButton.heightAnchor.constraint(equalToConstant: 44),
            deleteCardButton.trailingAnchor.constraint(equalTo: backCardButton.leadingAnchor, constant: -8),
            
            backCardButton.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -57),
            backCardButton.topAnchor.constraint(equalTo: deleteCardLabel.bottomAnchor, constant: 20),
            backCardButton.heightAnchor.constraint(equalTo: deleteCardButton.heightAnchor),
            backCardButton.widthAnchor.constraint(equalTo: deleteCardButton.widthAnchor),
            
            backCardButton.leadingAnchor.constraint(equalTo: deleteCardButton.trailingAnchor, constant: 8)
        ])
    }
    
    
    // MARK: - Objc Methods:
    
    @objc private func didTapDeleteCardButton() {
        delegate?.didTapDeleteCardButton(index: idNftToDelete)
    }
    
    @objc private func didTapbackCardButton() {
        delegate?.backButtonClicked()
    }
}

