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
        static let horisontalStackSpacing = CGFloat(20)
        static let verticalStackSpacing = CGFloat(10)
        static let textViewLineSpacing = CGFloat(5)
        static let userImageSize = CGFloat(70)
        static let heigtTableCell = CGFloat(54)
        static let countCellTableView = CGFloat(3)
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
        // TODO: - delete
        fullNameLabelView.text = "Mashuk Grigoriy"
        fullNameLabelView.textAlignment = .left
        fullNameLabelView.font = .headline3
        fullNameLabelView.textColor = .blackUniversal
        
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
        descriptionTextView.font = .caption2
        // TODO: - delete
        descriptionTextView.text = "sbcahvupw';';'aasqw[qpwruituiweurytXmnbvadfhaewrtyuetfg"
        descriptionTextView.textColor = .blackUniversal
        
        return descriptionTextView
    }()
    
    private lazy var linkLabelView: UILabel = {
        let linkLabelView = UILabel()
        linkLabelView.font = .systemFont(ofSize: 13)
        // TODO: - delete
        linkLabelView.text = "www.yandex.ru"
        linkLabelView.textColor = .blueUniversal
        return linkLabelView
    }()
    
    private lazy var nftTableView: UITableView = {
        let nftTableView = UITableView()
        nftTableView.translatesAutoresizingMaskIntoConstraints = false
        nftTableView.backgroundColor = .clear
        nftTableView.separatorStyle = .none
        nftTableView.register(ProfileTableViewCell.self,
                              forCellReuseIdentifier: "\(ProfileTableViewCell.self)")
        nftTableView.delegate = self
        nftTableView.dataSource = self
        
        return nftTableView
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
        setupTableView()
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
            userImageView.widthAnchor.constraint(equalToConstant: ConstantsProfileVC.userImageSize),
            userImageView.heightAnchor.constraint(equalToConstant: ConstantsProfileVC.userImageSize)
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
    
    func setupTableView() {
        view.addSubview(nftTableView)
        NSLayoutConstraint.activate([
            nftTableView.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 40),
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftTableView.heightAnchor.constraint(equalToConstant: ConstantsProfileVC.countCellTableView
                                                 * ConstantsProfileVC.heigtTableCell)
        ])
    }
}

extension ProfileViewController: NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        ConstantsProfileVC.textViewLineSpacing
    }
}

extension ProfileViewController: UITableViewDelegate {
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Int(ConstantsProfileVC.countCellTableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ConstantsProfileVC.heigtTableCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ProfileTableViewCell.self)") as? ProfileTableViewCell else { return UITableViewCell()}
        //TODO: - FIX (add viewModel)
        let cellModel = ProfileCellModel(text: "stub")
        cell.config(with: cellModel)
        return cell
    }
    
    
}
