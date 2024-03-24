//
//  OnboardingViewControllerBase.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 03.03.2024.
//

import Foundation
import UIKit

final class OnboardingViewControllerBase: UIViewController {
    
    private let imageName: String
    private let titleLabelText: String
    private let labelText: String
    private let button: UIButton?
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .SF32bold
        label.text = titleLabelText
        label.textColor = Asset.Colors.whiteUniversal.color
        label.textAlignment = .left
        return label
    }()
    
    lazy private var label: UILabel = {
        let label = UILabel()
        label.text = labelText
        label.font = .SF15regular
        label.textColor = Asset.Colors.whiteUniversal.color
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy private var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = Asset.Colors.whiteUniversal.color
        button.addTarget(self, action: #selector(didTapOnboardingButton), for: .touchUpInside)
        return button
    }()
    
    init(imageName: String, titleLabelText: String, labelText: String, button: UIButton?) {
        self.imageName = imageName
        self.titleLabelText = titleLabelText
        self.labelText = labelText
        if let button = button {
            self.button = button
        } else {
            self.button = nil
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUp() {
        
        button?.addTarget(self, action: #selector(didTapOnboardingButton), for: .touchUpInside)
        imageView.image = UIImage(named: imageName)

        view.insertSubview(imageView, at: 0)
        imageView.constraintEdges(to: view)
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [Asset.Colors.blackUniversal.color.cgColor, Asset.Colors.whiteUniversal.color.withAlphaComponent(0).cgColor]
        imageView.layer.insertSublayer(gradientLayer, at: 0)
        [titleLabel, label].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 230),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        if let button = button {
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(didTapOnboardingButton), for: .touchUpInside)
            NSLayoutConstraint.activate([
                button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                button.heightAnchor.constraint(equalToConstant: 60)
            ])
        } else {
            view.addSubview(closeButton)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
                closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                closeButton.heightAnchor.constraint(equalToConstant: 42),
                closeButton.widthAnchor.constraint(equalToConstant: 42)
            ])
        }
    }
    @objc func didTapOnboardingButton() {
        
        let servicesAssembly = ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl()
        )
        
        let tabBarController = TabBarController(servicesAssembly: servicesAssembly)
                
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "SkippedUnboarding")
        
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true, completion: nil)
    }
}
