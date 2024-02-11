//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Григорий Машук on 10.02.24.
//

import UIKit

final class EditProfileViewController: UIViewController {
    private enum ConstansEditVC {
        static let editButtonSize = CGSize(width: 42, height: 42)
        static let editImageViewSize = CGSize(width: 70, height: 70)
        static let exitImage = UIImage(named: "close")
        static let editImageViewAlphaComponent = CGFloat(0.6)
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
    
    private lazy var userEditImageView: UIView = {
        let userEditImageView = UIView(frame: CGRect(origin: .zero,
                                                     size: ConstansEditVC.editImageViewSize))
        
        return userEditImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteUniversal
        setupUIItem()
    }
}

private extension EditProfileViewController {
    private func setupUIItem() {
        setupExitButton()
        setupUserImageView()
        setupUserEditImageView()
    }
    
    func setupExitButton() {
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.backgroundColor = .clear
        exitButton.tintColor = .blackUniversal
        exitButton.setImage(ConstansEditVC.exitImage, for: .normal)
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
    }
    
    func setupUserEditImageView() {
        userImageView.addSubview(userEditImageView)
        userEditImageView.translatesAutoresizingMaskIntoConstraints = false
        userEditImageView.backgroundColor =
            .blackUniversal.withAlphaComponent(ConstansEditVC.editImageViewAlphaComponent)
        userEditImageView.center = userImageView.center
    }
}
