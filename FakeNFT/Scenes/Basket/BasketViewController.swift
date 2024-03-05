//
//  BasketViewController.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 09.02.2024.
//

import UIKit

final class BasketViewController: UIViewController, LoadingView {
    
    // MARK: - Private properties:
    
    private let viewModel: BasketViewModelProtocol
    
    private var sortedAlertPresenter: SortAlertPresenterProtocol?
    
    private let paymentViewModel: PaymentViewModelProtocol
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "Sort"),
            style: .plain,
            target: self,
            action: #selector(didTapSortButton)
        )
        button.tintColor = .segmentActive
        return button
    }()
    
    internal lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - UI Elements
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .segmentInactive
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.segmentActive
        button.tintColor = .whiteModeThemes
        button.setTitle(ConstLocalizable.basketToBePaid, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var counterNftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .segmentActive
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var quantityNftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .greenUniversal
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .systemBackground
        tableView.register(BasketTableViewCell.self, forCellReuseIdentifier: BasketTableViewCell.identifier)
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = ConstLocalizable.basketIsEmpty
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .segmentActive
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.decelerationRate = .fast
        scroll.isHidden = true
        return scroll
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        return UIVisualEffectView(effect: blurEffect)
    }()
    
    private lazy var deleteCardView = BasketDeleteCardView()
    
    // MARK: - Initializers
    
    init(viewModel: BasketViewModelProtocol, paymentViewModel: PaymentViewModelProtocol) {
        self.viewModel = viewModel
        self.paymentViewModel = paymentViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        deleteCardView.delegate = self
        bindViewModel()
        sortedAlertPresenter = SortAlertPresenter(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadNftData()
        setupNavBar()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        view.addSubview(bottomView)
        view.addSubview(counterNftLabel)
        view.addSubview(quantityNftLabel)
        view.addSubview(paymentButton)
        scrollView.addSubview(tableView)
        view.addSubview(stubLabel)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        activityIndicator.constraintCenters(to: view)
        
        NSLayoutConstraint.activate([
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 76),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            scrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: scrollView.frameLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            counterNftLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            counterNftLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            counterNftLabel.bottomAnchor.constraint(equalTo: quantityNftLabel.topAnchor, constant: -2),
            
            quantityNftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            quantityNftLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
            
            paymentButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            paymentButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
            paymentButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            paymentButton.leadingAnchor.constraint(equalTo: quantityNftLabel.trailingAnchor, constant: 24),
            
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavBar() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    private func bindViewModel() {
        viewModel.onSortButtonClicked = { [weak self] in
            guard let self else { return }
            self.setupFilters()
        }
        
        viewModel.onChange = { [weak self] nftCount, nftQuantity in
            guard let self else { return }
            self.tableView.reloadData()
            self.counterNftLabel.text = nftCount
            self.quantityNftLabel.text = nftQuantity
        }
        
        viewModel.onLoad = { [weak self] onLoad in
            guard let self else { return }
            if onLoad {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.setupStubLabel()
            }
        }
    }
    
    private func setupBlurView() {
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBarController?.view.addSubview(blurEffectView)
        tabBarController?.view.addSubview(deleteCardView)
        deleteCardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deleteCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deleteCardView.topAnchor.constraint(equalTo: view.topAnchor),
            deleteCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupFilters() {
        sortedAlertPresenter?.showAlert(model: SortAlertModel(
            title: ConstLocalizable.basketSort,
            message: nil,
            actionSheetTextFirst: ConstLocalizable.basketSortPrice,
            actionSheetTextSecond: ConstLocalizable.basketSortRait,
            actionSheetTextThird: ConstLocalizable.basketSortName,
            actionSheetTextCancel: ConstLocalizable.basketClose,
            completionFirst: { [weak self] in
                guard let self else { return }
                self.viewModel.sortItems(with: .price)
            },
            completionSecond: { [weak self] in
                guard let self else { return }
                self.viewModel.sortItems(with: .rating)
            },
            completionThird: { [weak self] in
                guard let self else { return }
                self.viewModel.sortItems(with: .name)
            }
        ))
    }
    
    private func setupStubLabel() {
        let isEmptyNFT = viewModel.nftItems.isEmpty
        bottomView.isHidden = isEmptyNFT
        scrollView.isHidden = isEmptyNFT
        tableView.isHidden = isEmptyNFT
        counterNftLabel.isHidden = isEmptyNFT
        quantityNftLabel.isHidden = isEmptyNFT
        paymentButton.isHidden = isEmptyNFT
        stubLabel.isHidden = !isEmptyNFT
        
        if isEmptyNFT {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    // MARK: - Objc Methods
    
    @objc private func didTapSortButton() {
        viewModel.sortButtonClicked()
    }
    
    @objc private func didTapPayButton() {
        let viewController = PaymentViewController(viewModel: paymentViewModel)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

// MARK: - UITableViewDataSource

extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.nftItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketTableViewCell.identifier) as? BasketTableViewCell else {
            return UITableViewCell()
        }
        let nft = viewModel.nftItems[indexPath.row]
        cell.configure(with: nft)
        cell.delegate = self
        return cell
    }
}

// MARK: - BasketTableViewCellDelegate

extension BasketViewController: BasketTableViewCellDelegate {
    func deleteButtonClicked(image: UIImage, id: String) {
        setupBlurView()
        deleteCardView.configureView(image: image, id: id)
    }
}

// MARK: - BasketDeleteCardViewDelegate

extension BasketViewController: BasketDeleteCardViewDelegate {
    func didTapDeleteCardButton(index: String) {
        blurEffectView.removeFromSuperview()
        deleteCardView.removeFromSuperview()
        viewModel.deleteNft(index: index)
    }
    
    func backButtonClicked() {
        blurEffectView.removeFromSuperview()
        deleteCardView.removeFromSuperview()
    }
}

extension BasketViewController: PaymentViewControllerDelegate {
    func updateNftAfterPay() {
        viewModel.deleteAllNft()
    }
}
