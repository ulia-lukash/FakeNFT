//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Григорий Машук on 9.02.24.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private enum ConstantsProfileVC {
        static let editImage = "EditDark"
        static let stubImage = "User Pic"
        static let fullNameFont = UIFont.boldSystemFont(ofSize: 22)
        static let descriptionFont = UIFont.systemFont(ofSize: 13)
        static let linkFont = UIFont.systemFont(ofSize: 15)
        static let horisontalStackSpacing = CGFloat(20)
        static let verticalStackSpacing = CGFloat(10)
        static let userImageSize = CGSize(width: 70, height: 70)
    }
    private lazy var editProfileButton: UIButton = {
        let editProfileButton = UIButton()
        editProfileButton.setImage(UIImage(named: ConstantsProfileVC.editImage),
                                   for: .normal)
        
        return editProfileButton
    }()
    
    private lazy var horisontalStackView: UIStackView = {
        let horisontalStackView = UIStackView()
        horisontalStackView.axis = .horizontal
        horisontalStackView.spacing = ConstantsProfileVC.horisontalStackSpacing
        
        return horisontalStackView
    }()
    
    private lazy var userImageView: UIImageView = {
        let userImageView = UIImageView(image: UIImage(named: ConstantsProfileVC.stubImage))
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        userImageView.layer.masksToBounds = true
        
        return userImageView
    }()
    
    private lazy var fullNameLabelView: UILabel = {
        let fullNameLabelView = UILabel()
        fullNameLabelView.text = "Mashuk Grigoriy"
        fullNameLabelView.textAlignment = .left
        fullNameLabelView.font = ConstantsProfileVC.fullNameFont
        fullNameLabelView.textColor = .black
        
        return fullNameLabelView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = ConstantsProfileVC.verticalStackSpacing
        
        return verticalStackView
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let descriptionTextView = UITextView()
        descriptionTextView.textAlignment = .left
        descriptionTextView.layoutManager.delegate = self
        descriptionTextView.font = ConstantsProfileVC.descriptionFont
        descriptionTextView.text = "sbcahvupw';';'aasqw[qpwruituiweurytXmnbvajhdbdfbdfbdfdfbdfbbdfbdfbdfbdfbeoiuotsdjfgwueyrtcvnbsdfhaewrtyuetfg"
        descriptionTextView.textColor = .black
        
        return descriptionTextView
    }()
    
    private lazy var linkLabelView: UILabel = {
        let linkLabelView = UILabel()
        linkLabelView.font = .systemFont(ofSize: 13)
        linkLabelView.text = "www.yandex.ru"
        linkLabelView.textColor = .blue
        return linkLabelView
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
        setupHorisontalStack()
        setupVerticalStackView()
    }
    
    func setupEditProfileImageView() {
        view.addSubview(editProfileButton)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            editProfileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            editProfileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9)
        ])
    }
    
    func setupHorisontalStack() {
        [userImageView, fullNameLabelView].forEach {
            horisontalStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: horisontalStackView.leadingAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 70),
            userImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func setupVerticalStackView() {
        view.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        [horisontalStackView, descriptionTextView, linkLabelView].forEach {
            verticalStackView.addArrangedSubview($0)
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 20),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            descriptionTextView.bottomAnchor.constraint(equalTo: linkLabelView.topAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
}

extension ProfileViewController: NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        5
    }
}
