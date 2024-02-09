//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Григорий Машук on 9.02.24.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private struct ConstantsProfileVC {
        static let editImage = "EditDark"
    }
    private lazy var editProfileImageView: UIImageView = {
        let editProfileImageView = UIImageView()
        editProfileImageView.image = UIImage(named: ConstantsProfileVC.editImage)
        
        return editProfileImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUIItem()
    }
}

private extension ProfileViewController {
    func setupUIItem() {
        setupEditProfileImageView()
    }
    
    func setupEditProfileImageView() {
        view.addSubview(editProfileImageView)
        editProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        editProfileImageView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            editProfileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            editProfileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9)
        ])
    }
}
