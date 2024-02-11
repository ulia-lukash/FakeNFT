//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Григорий Машук on 10.02.24.
//

import UIKit

final class EditProfileViewController: UIViewController {
    private enum ConstansEditVC: String {
        static let editButtonSize = CGSize(width: 42, height: 42)
        static let editImageViewSize = CGSize(width: 70, height: 70)
        static let editImageViewAlphaComponent = CGFloat(0.6)
        static let spacingStackView = CGFloat(22)
        static let editLabelNumberOfLines = 2
        case close
    }
    
    private lazy var exitButton: UIButton = {
        let exitButton = UIButton(frame: CGRect(origin: .zero,
                                                size: ConstansEditVC.editButtonSize))
        
        return exitButton
    }()
    
    private lazy var userImageView: UIImageView = {
        let userImageView = UserImageView(image: nil)
        let userImageModel = UserImageModel(url: nil)
        userImageView.config(with: userImageModel)
        
        return userImageView
    }()
    
    private lazy var userEditLabelView: UILabel = {
        let userEditLabelView = UILabel(frame: CGRect(origin: .zero,
                                                      size: ConstansEditVC.editImageViewSize))
        userEditLabelView.text = ConstLocalizable.editUserImage
        userEditLabelView.numberOfLines = ConstansEditVC.editLabelNumberOfLines
        userEditLabelView.textAlignment = .center
        userEditLabelView.textColor = .whiteUniversal
        userEditLabelView.font = .headline6
        userEditLabelView.frame = userImageView.frame
        
        return userEditLabelView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let verticalStackView = UIStackView()
        verticalStackView.spacing = ConstansEditVC.spacingStackView
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.backgroundColor = .clear
        
        return verticalStackView
    }()
    
    private lazy var nameLabelView: UILabel = {
        let nameLabelView = UILabel()
        
        return nameLabelView
    }()
    
    private lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        
        return nameTextField
    }()
    
    private lazy var descriptionLabelView: UILabel = {
        let descriptionLabelView = UILabel()
        
        return descriptionLabelView
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let descriptionTextField = UITextField()
        
        return descriptionTextField
    }()
    
    private lazy var linkLabelView: UILabel = {
        let linkLabelView = UILabel()
        
        return linkLabelView
    }()
    
    private lazy var linkTextField: UITextField = {
        let linkTextField = UITextField()
        
        return linkTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteUniversal
        setupUIItem()
    }
}

private extension EditProfileViewController {
    func setupUIItem() {
        setupExitButton()
        setupUserImageView()
        setupUserEditImageView()
    }
    
    func setupExitButton() {
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.backgroundColor = .clear
        exitButton.tintColor = .blackUniversal
        exitButton.setImage(UIImage(named: ConstansEditVC.close.rawValue),
                            for: .normal)
        view.addSubview(exitButton)
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func setupUserImageView() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.backgroundColor = .clear
        view.addSubview(userImageView)
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 22),
            userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImageView.heightAnchor.constraint(equalToConstant: 70),
            userImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
        setupUserImageTap()
    }
    
    func setupUserEditImageView() {
        userImageView.addSubview(userEditLabelView)
        userEditLabelView.backgroundColor =
            .blackUniversal.withAlphaComponent(ConstansEditVC.editImageViewAlphaComponent)
    }
    
    func setupUserImageTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.userImageTapped(_:)))
        self.userImageView.isUserInteractionEnabled = true
        self.userImageView.addGestureRecognizer(labelTap)
    }
    
    @objc
    func userImageTapped(_ sender: UITapGestureRecognizer) {
        //TODO: - fix
        print(#function)
    }
}
