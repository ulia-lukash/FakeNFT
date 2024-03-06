import UIKit

final class NFTCollectionViewController: UIViewController, LoadingView, ErrorView {
    internal lazy var activityIndicator = UIActivityIndicatorView()

    private let viewModel: NFTCollectionViewModelProtocol

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    init(viewModel: NFTCollectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteModeThemes

        setupNavBar()
        setupCollectionView()
        setupViewModel()

        viewModel.viewDidLoad()
    }

    private func setupViewModel() {
        viewModel.onLoadingState = { [weak self] in
            self?.showLoading()
        }
        viewModel.onDataState = { [weak self] in
            self?.hideLoading()
        }
        viewModel.onErrorState = { [weak self] error in
            self?.hideLoading()
            self?.showError(error)
        }
        viewModel.onNFTCollectionChange = { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    private func setupNavBar() {
        let backButton = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        backButton.tintColor = UIColor.segmentActive
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        title = NSLocalizedString("NFTCollection.screenTitle", comment: "screen title")
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NFTCell.self, forCellWithReuseIdentifier: "NFTCell")

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(activityIndicator)

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.collectionViewTopInset
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.defaultInset
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.defaultInset
            ),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension NFTCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.userNFTCollection.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NFTCell", for: indexPath) as? NFTCell

        let nft = viewModel.userNFTCollection[indexPath.row]
        cell?.setupCell(using: nft)
        cell?.delegate = viewModel

        guard let cell = cell else {
            return NFTCell()
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NFTCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / Constants.nftsPerLine -
        Constants.minInteritemSpacing * (Constants.nftsPerLine - 1)

        return CGSize(width: width, height: Constants.nftCardHeight)
    }
}

private enum Constants {
    static let collectionViewTopInset: CGFloat = 20
    static let defaultInset: CGFloat = 16
    static let minInteritemSpacing: CGFloat = 9
    static let nftsPerLine: CGFloat = 3
    static let nftCardHeight: CGFloat = 192
}
