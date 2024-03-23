//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Григорий Машук on 9.02.24.
//

import UIKit
import Kingfisher

protocol ProfileVCEditDelegate: AnyObject {
    func setDataUI(model: ProfileUIModel)
}

protocol ProfileVCMyNftDelegate: AnyObject {
    func setProfile(model: Profile?, vc: UIViewController)
}

protocol ProfileVCFavoriteDelegate: AnyObject {
    func setLikesId(model: Profile, vc: UIViewController)
}

// MARK: - ProfileViewController
final class ProfileViewController: UIViewController, ErrorView {
    private enum ConstantsProfileVC: String {
        static let assertionMEssage = "can't move to initial state"
        static let horisontalStackSpacing = CGFloat(20)
        static let verticalStackSpacing = CGFloat(20)
        static let textViewLineSpacing = CGFloat(3)
        static let userImageSize = CGFloat(70)
        static let paddingTextView = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        static let heigtTableCell = CGFloat(54)
        static let countCellTableView = 3
        static let maxHeightTextView = CGFloat(100)
        case editProfile
    }
    
    private var router: Router?
    weak var editDelegate: ProfileVCEditDelegate?
    weak var myNftDelegate: ProfileVCMyNftDelegate?
    weak var favoriteDelegate: ProfileVCFavoriteDelegate?
    private var textHeightConstraint: NSLayoutConstraint?
    private let viewModel: ProfileViewModelProtocol
    
    private lazy var editProfileButton: UIBarButtonItem = {
        let image = UIImage(systemName: "square.and.pencil")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.didEditTap))
        button.tintColor = Asset.Colors.black.color
        return button
    }()
    
    private lazy var userImageView: UIImageView = {
        let image = Asset.placeholderUser.image
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var fullNameLabelView: UILabel = {
        let fullNameLabelView = UILabel()
        fullNameLabelView.textAlignment = .left
        fullNameLabelView.font = .headline3
        fullNameLabelView.textColor = Asset.Colors.black.color
        
        return fullNameLabelView
    }()
    
    private lazy var descriptionTextView: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .caption2
        label.textColor = Asset.Colors.black.color
        
        return label
    }()
    
    private lazy var linkLabelView: UILabel = {
        let linkLabelView = UILabel()
        linkLabelView.font = .caption1
        linkLabelView.textColor = .blueUniversal
        return linkLabelView
    }()
    
    private lazy var nftTableView: UITableView = {
        let nftTableView = UITableView()
        nftTableView.translatesAutoresizingMaskIntoConstraints = false
        nftTableView.backgroundColor = .clear
        nftTableView.separatorStyle = .none
        nftTableView.isScrollEnabled = false
        nftTableView.register(ProfileTableViewCell.self)
        nftTableView.delegate = self
        nftTableView.dataSource = self
        
        return nftTableView
    }()
    
    lazy var loadingView: UIView = {
        let loadingView = UIView()
        loadingView.backgroundColor = Asset.Colors.white.color
        return loadingView
    }()
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = Asset.Colors.black.color
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
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
        router = Router(sourceViewController: self)
        view.backgroundColor = Asset.Colors.white.color
        bind()
        setupUIItem()
        viewModel.setStateLoading()
    }
}

private extension ProfileViewController {
    // MARK: - private function
    func bind() {
        guard let viewModel = viewModel as? ProfileViewModel else { return }
        viewModel.$state.bind { [weak self] state in
            guard let self else { return }
            switch state {
            case .initial:
                assertionFailure(ConstantsProfileVC.assertionMEssage)
            case .loading:
                self.enableUserInteraction(flag: false)
                viewModel.loadProfile(id: "1")
            case .update:
                self.enableUserInteraction(flag: false)
            case .failed(let error):
                self.hideLoading()
                let errorModel = viewModel.makeErrorModel(error: error)
                self.showError(errorModel)
            case .data(let profile):
                let profileUIModel = viewModel.makeProfileUIModel(networkModel: profile)
                viewModel.setProfileUIModel(model: profileUIModel)
                viewModel.setProfileID(id: profile.id)
                let cellModel = viewModel.makeTableCellModel(networkModel: profile)
                viewModel.setCellModel(cellModel: cellModel)
                self.displayProfile(model: profileUIModel)
                self.enableUserInteraction(flag: true)
            }
        }
        viewModel.$cellModel.bind { [weak self] _ in
            guard let self else { return }
            self.nftTableView.reloadData()
        }
    }
    
    func enableUserInteraction(flag: Bool) {
        if flag {
            hideLoading()
        } else {
            showLoading()
        }
        view.isUserInteractionEnabled = flag
    }
    
    private func hideLoading() {
        loadingView.isHidden = true
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    private func showLoading() {
        loadingView.isHidden = false
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    @objc
    func didEditTap() {
        let editVC = EditProfileViewController(delegate: self)
        self.editDelegate = editVC
        editVC.modalPresentationStyle = .formSheet
        present(editVC, animated: true) { [weak self] in
            guard let self,
                  let model = self.viewModel.getProfileUIModel() else { return }
            self.editDelegate?.setDataUI(model: model)
        }
    }
    
    func displayProfile(model: ProfileUIModel) {
        userImageView.kf.indicatorType = .activity
        userImageView.kf.setImage(
            with: model.avatar) { result in
                switch result {
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                default:
                    break
                }
            }
        fullNameLabelView.text = viewModel.stringClear(str: model.name)
        descriptionTextView.text = viewModel.stringClear(str: model.description)
        linkLabelView.text = viewModel.stringClear(str: model.link)
    }
    
    func displayMyNft() {
        guard let router,
              let profile = viewModel.getProfile()
        else { return }
        router.showMyNft(profile: profile)
    }
    
    func displayFavoriteNft() {
        guard let profile = viewModel.getProfile(),
              let router
        else { return }
        router.showFavarite()
        favoriteDelegate?.setLikesId(model: profile, vc: self)
    }
    
    func displayWebView() {
        guard let request = viewModel.createRequest(
            WebViewConfiguration.baseUrlSring),
            let router
        else { return }
        router.showWebView(request: request)
    }
    
    // MARK: - setupUI function
    func setupUIItem() {
        addSubViewsAndBackColor()
        setupConstraint()
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userImageView.heightAnchor.constraint(equalToConstant: 70),
            userImageView.widthAnchor.constraint(equalToConstant: 70),
            
            fullNameLabelView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            fullNameLabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            fullNameLabelView.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            linkLabelView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8),
            linkLabelView.heightAnchor.constraint(equalToConstant: 38),
            linkLabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            linkLabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            nftTableView.topAnchor.constraint(equalTo: linkLabelView.bottomAnchor, constant: 40),
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftTableView.heightAnchor.constraint(equalToConstant: CGFloat(ConstantsProfileVC.countCellTableView)
                                                 * ConstantsProfileVC.heigtTableCell),
        ])
        activityIndicator.constraintCenters(to: loadingView)
        loadingView.constraintEdges(to: view)
    }
    
    func addSubViewsAndBackColor() {
        [userImageView, fullNameLabelView, descriptionTextView,
         linkLabelView, nftTableView, loadingView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        loadingView.addSubview(activityIndicator)
        self.navigationItem.rightBarButtonItem = editProfileButton
    }
}

// MARK: - NSLayoutManagerDelegate
extension ProfileViewController: NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager,
                       lineSpacingAfterGlyphAt glyphIndex: Int,
                       withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        ConstantsProfileVC.textViewLineSpacing
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == CountProfileCell.one.rawValue {
            displayMyNft()
        }
        if indexPath.row == CountProfileCell.two.rawValue {
            displayFavoriteNft()
        }
        if indexPath.row == CountProfileCell.three.rawValue {
            displayWebView()
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Int(ConstantsProfileVC.countCellTableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ConstantsProfileVC.heigtTableCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(ProfileTableViewCell.self)") as? ProfileTableViewCell,
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

// MARK: - EditProfileVCDelegate
extension ProfileViewController: EditProfileVCDelegate {
    func update(profile: ProfileUIModel) {
        viewModel.updateProfile(newModel: profile)
    }
}

// MARK: - MyNFTViewControllerDlegate
extension ProfileViewController: MyNFTViewControllerDlegate {
    func updateProfileForMyNft(vc: UIViewController) {
        viewModel.loadProfile(id: "1")
        viewModel.setStateLoading()
    }
}

// MARK: - FavoriteViewControllerDelegate
extension ProfileViewController: FavoriteViewControllerDelegate {
    func updateProfileForLikes(vc: UIViewController) {
        viewModel.loadProfile(id: "1")
        viewModel.setStateLoading()
    }
}
