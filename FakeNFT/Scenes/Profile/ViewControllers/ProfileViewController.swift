//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Григорий Машук on 9.02.24.
//

import UIKit
import Kingfisher

protocol ProfileVCDelegate: AnyObject {
    func setDataUI(model: ProfileUIModel)
}

final class ProfileViewController: UIViewController {
    private enum ConstantsProfileVC: String {
        static let assertionMEssage = "can't move to initial state"
        static let horisontalStackSpacing = CGFloat(20)
        static let verticalStackSpacing = CGFloat(10)
        static let textViewLineSpacing = CGFloat(5)
        static let userImageSize = CGFloat(70)
        static let heigtTableCell = CGFloat(54)
        static let paddingTextView = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let countCellTableView = 3
        case editProfile
    }
    
    weak var delegate: ProfileVCDelegate?
    
    private let viewModel: ProfileViewModelProtocol
    
    internal lazy var activityIndicator = UIActivityIndicatorView()
    
    private lazy var editProfileButton: UIButton = {
        let editProfileButton = UIButton()
        editProfileButton.addTarget(nil, action: #selector(self.didEditTap), for: .touchUpInside)
        editProfileButton.setImage(UIImage(named: ConstantsProfileVC.editProfile.rawValue),
                                   for: .normal)
        
        return editProfileButton
    }()
    
    private lazy var horisontalStackView: UIStackView = {
        let horisontalStackView = UIStackView()
        horisontalStackView.axis = .horizontal
        horisontalStackView.spacing = ConstantsProfileVC.horisontalStackSpacing
        
        return horisontalStackView
    }()
    
    private lazy var userImageView: UserImageView = {
        let userImageView = UserImageView(image: nil)
        let userImageModel = UserImageModel(url: nil)
        userImageView.config(with: userImageModel)
        
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
        descriptionTextView.setPadding(insets: ConstantsProfileVC.paddingTextView)
        // TODO: - delete
        descriptionTextView.text = "sbcahvupw';';'aasqw[qpwruituiweThanks a bunch! always used addSubview positioning stuff inside of my cells, but contentView.addSubview is what worked. +1 for linked tutorial as well –"
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
    
    // MARK: - Init
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //        bind()
        view.backgroundColor = .whiteUniversal
        setupUIItem()
        viewModel.setStateLoading()
    }
}

private extension ProfileViewController {
    //MARK: - private function
    func bind() {
        guard let viewModel = viewModel as? ProfileViewModel else { return }
        viewModel.$state.bind { [weak self] state in
            guard let self else { return }
            switch state {
            case .initial:
                assertionFailure(ConstantsProfileVC.assertionMEssage)
            case .loading:
                self.showLoading()
                viewModel.loadProfile(id: "1")
            case .failed(let error):
                self.hideLoading()
                let errorModel = viewModel.makeErrorModel(error: error)
                self.showError(errorModel)
            case .data(let profile):
                self.hideLoading()
                let profileUIModel = viewModel.makeProfileUIModel(networkModel: profile)
                viewModel.setProfileUIModel(model: profileUIModel)
                let cellModel = viewModel.makeTableCellModel(networkModel: profile)
                viewModel.setCellModel(cellModel: cellModel)
                self.displayProfile(model: profileUIModel)
            }
        }
        
        viewModel.$cellModel.bind { [weak self] cellModel in
            guard let self else { return }
            nftTableView.reloadData()
        }
    }
    
    @objc
    func didEditTap() {
        let editVC = EditProfileViewController(delegate: self)
        self.delegate = editVC
        editVC.modalPresentationStyle = .formSheet
        present(editVC, animated: true) { [weak self] in
            guard let self,
                  let model = self.viewModel.getProfileUIModel() else { return }
            delegate?.setDataUI(model: model)
        }
    }
    
    func displayProfile(model: ProfileUIModel) {
        userImageView.config(with: UserImageModel(url: model.url))
        fullNameLabelView.text = model.name
        descriptionTextView.text = model.description
        linkLabelView.text = model.link
    }
    
    //MARK: - setupUI function
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
            nftTableView.heightAnchor.constraint(equalToConstant: CGFloat(ConstantsProfileVC.countCellTableView)
                                                 * ConstantsProfileVC.heigtTableCell)
        ])
    }
}

//MARK: - NSLayoutManagerDelegate
extension ProfileViewController: NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        ConstantsProfileVC.textViewLineSpacing
    }
}

//MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
}

//MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Int(ConstantsProfileVC.countCellTableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ConstantsProfileVC.heigtTableCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ProfileTableViewCell.self)") as? ProfileTableViewCell,
              let viewModel = viewModel as? ProfileViewModel
        else { return UITableViewCell()}
        let cellModel = viewModel.cellModel
        switch indexPath.row {
        case 0:
            let text = viewModel.createTextCell(text: ConstLocalizable.profileCellMyNFT,
                                                count: cellModel.countNFT)
            let profileCellModel = ProfileCellModel(text: text)
            cell.config(with: profileCellModel)
        case 1:
            let text = viewModel.createTextCell(text: ConstLocalizable.profileCellFavoritesNFT,
                                                count: cellModel.countFavoritesNFT)
            let profileCellModel = ProfileCellModel(text: text)
            cell.config(with: profileCellModel)
        case 2:
            let profileCellModel = ProfileCellModel(text: ConstLocalizable.profileCellDeveloper )
            cell.config(with: profileCellModel)
        default:
            assertionFailure("")
        }
        return cell
    }
}

// MARK: - ErrorView, LoadingView
extension ProfileViewController: ErrorView, LoadingView {}


extension ProfileViewController: EditProfileVCDelegate {}
