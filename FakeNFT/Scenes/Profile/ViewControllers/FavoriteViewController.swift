//
//  FavoriteViewController.swift
//  FakeNFT
//
//  Created by Григорий Машук on 26.02.24.
//

import UIKit

protocol FavoriteViewControllerDelegate: AnyObject {
    func updateProfileForLikes(vc: UIViewController)
}

final class FavoriteViewController: UIViewController, ErrorView, LoadingView {
    private enum ConstansFavorite: String {
        static let cellCount: Int = 2
        static let cellSpacing = CGFloat(12)
        static let heightCell = CGFloat(80)
        case backwardProfile
    }
    
    weak var delegate: FavoriteViewControllerDelegate?
    
    private let viewModel: FavoriteViewModelProtocol
    
    private lazy var nftCollectionView: FavoritesCollectionView = {
        let nftCollectionView = сreateTrackerCollectionView()
        nftCollectionView.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionView.backgroundColor = .segmentActive
        nftCollectionView.register(FavoriteCollectionCell.self,
                                   forCellWithReuseIdentifier: "\(FavoriteCollectionCell.self)")
        nftCollectionView.delegate = self
        nftCollectionView.dataSource = self
        
        return nftCollectionView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .blackUniversal
        
        return activityIndicator
    }()
    
    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .segmentActive
        setupCollectionView()
        setupActivityIndicator()
        viewModel.loadNftLikes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let delegate else { return }
        delegate.updateProfileForLikes(vc: self)
    }
}

private extension FavoriteViewController {
    //MARK: - private func
    @objc
    func leftBarButtonItemTap() {
        dismiss(animated: true)
    }
    
    func bind() {
        guard let viewModel = viewModel as? FavoriteViewModel else { return }
        viewModel.$state.bind { [weak self] state in
            guard let self else { return }
            switch state {
            case .initial:
                assertionFailure("can't move to initial state")
            case .loading, .update:
                self.view.isUserInteractionEnabled = false
                self.showLoading()
            case .failed(let _):
                break
                //TODO: - viewModel
            case .data:
                guard let indexPath = viewModel.likeIndexPath else { return }
                nftCollectionView.reloadItems(at: [indexPath])
                    self.hideLoading()
                    view.isUserInteractionEnabled = true
                    return
            }
        }
    }
    
    func сreateTrackerCollectionView() -> FavoritesCollectionView {
        let params = GeometricParams(cellCount: ConstansFavorite.cellCount,
                                     leftInset: .zero,
                                     rightInset: .zero,
                                     cellSpacing: ConstansFavorite.cellSpacing)
        let layout = UICollectionViewFlowLayout()
        let trackerCollectionView = FavoritesCollectionView(frame: .zero,
                                                          collectionViewLayout: layout,
                                                          params: params)
        return trackerCollectionView
    }
    
    func setupNavigationBar() {
        guard let navBar = navigationController?.navigationBar,
              let topItem = navBar.topItem
        else { return }
        topItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: ConstansFavorite.backwardProfile.rawValue),
                                                    style: .plain, target: self,
                                                    action: #selector(leftBarButtonItemTap))
        topItem.leftBarButtonItem?.tintColor = .blackUniversal
        topItem.rightBarButtonItem?.tintColor = .blackUniversal
        navBar.backgroundColor = .clear
        navigationItem.titleView?.tintColor = .blackUniversal
        navigationItem.title = ConstLocalizable.myNFTProfile
        self.navigationController?.navigationBar.barTintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blackUniversal]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func setupCollectionView() {
        view.addSubview(nftCollectionView)
        NSLayoutConstraint.activate([
            nftCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: view)
    }
}

//MARK: - UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel as? FavoriteViewModel else { return .zero }
        return Int(viewModel.likesNft.count)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(FavoriteCollectionCell.self)",
            for: indexPath) as? FavoriteCollectionCell
        else { return UICollectionViewCell() }
        cell.delegate = self
        cell.config(model: viewModel.createCellModel(index: indexPath.row))
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - nftCollectionView.params.paddingWidth
        let cellWidth = availableWidth / CGFloat(nftCollectionView.params.cellCount)
        let sizeCell = CGSize(width: cellWidth, height: ConstansFavorite.heightCell)
        
        return sizeCell
    }
}
//MARK: - UICollectionViewDelegate
extension FavoriteViewController: UICollectionViewDelegate {
    
}

//MARK: - ProfileVCFavoriteDelegate
extension FavoriteViewController: ProfileVCFavoriteDelegate {
    func setLikesId(model: Profile, vc: UIViewController) {
        viewModel.setLikesId(likesId: model.likes)
    }
}

extension FavoriteViewController: FavoriteCollectionCellDelegate {
    func likeTap(_ cell: UICollectionViewCell) {
        //TODO: - viewModel
    }
}
