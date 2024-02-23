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
    
    let paymentViewModel = PaymentViewModel(service: PaymentService(networkClient: DefaultNetworkClient()))
    
    // MARK: - UI
    
    private lazy var bottomView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.segmentInactive
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var paymentButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = UIColor.segmentActive
        button.tintColor = UIColor.whiteModeThemes
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var counterNftLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.segmentActive
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var quantityNftLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.greenUniversal
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
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
        var label = UILabel()
        label.text = "Корзина пуста"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.segmentActive
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isMultipleTouchEnabled = false
        scroll.isScrollEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.decelerationRate = .init(rawValue: 1)
        scroll.isHidden = true
        return scroll
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    private lazy var deleteCardView = BasketDeleteCardView()
    
    private lazy var rightButton = UIBarButtonItem(
        image: UIImage(named: "Sort"),
        style: .plain,
        target: self,
        action: #selector(didTapSortButton)
    )
    
    internal var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Initializers
    
    init(viewModel: BasketViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navBarItem()
        setupView()
        setupConstraints()
        deleteCardView.delegate = self
        setupViewModel()
        sortedAlertPresenter = SortAlertPresenter(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.loadNftData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
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
            stubLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupViewModel() {
        viewModel.onSortButtonClicked = { [weak self] in
            guard let self else { return }
            self.setupFilters()
        }
        
        viewModel.onChange = { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
            updateCounterLabel()
        }
        
        viewModel.onLoad = { [weak self] onLoad in
            guard let self else { return }
            onLoad ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            if onLoad == false {
                setupStubLabel()
            }
        }
    }
    
    private func updateCounterLabel() {
        viewModel.quantityNft = 0
        for a in 0..<viewModel.nft.count {
            viewModel.quantityNft += viewModel.nft[a].price
        }
        let formatterLabel = String(
            format:"%.2f", viewModel.quantityNft).replacingOccurrences(
                of: ".", with: ","
            )
        counterNftLabel.text = "\(viewModel.nft.count) NFT"
        quantityNftLabel.text = "\(formatterLabel) ETH"
    }
    
    private func navBarItem() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.largeTitleDisplayMode = .always
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
            deleteCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupFilters() {
        sortedAlertPresenter?.showAlert(
            model: SortAlertModel(
                title: "Сортировка",
                message: nil,
                actionSheetTextFirst: "По цене",
                actionSheetTextSecond: "По рейтингу",
                actionSheetTextThird: "По названию",
                actionSheetTextCancel: "Закрыть",
                completionFirst: { [weak self] in
                    guard let self else { return }
                    self.viewModel.sorting(with: .price)
                },
                completionSecond: { [weak self] in
                    guard let self else { return }
                    self.viewModel.sorting(with: .rating)
                },
                completionThird: { [weak self] in
                    guard let self else { return }
                    self.viewModel.sorting(with: .name)
                }
            ))
    }
    
    private func setupStubLabel() {
        let isEmptyNFT = viewModel.nft.isEmpty
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
            rightButton.tintColor = UIColor.segmentActive
            navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    @objc private func didTapSortButton() {
        viewModel.sortButtonClicked()
    }
    
    @objc private func didTapPayButton() {
        let viewController = PaymentViewController(viewModel: paymentViewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - UITableViewDelegate

extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

//MARK: - UITableViewDataSource

extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.nft.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketTableViewCell.identifier) as? BasketTableViewCell else {
            return UITableViewCell()
        }
        let nft = viewModel.nft[indexPath.row]
        cell.configureCell(for: nft)
        cell.delegate = self
        return cell
    }
}

//MARK: - BasketTableViewCellDelegate

extension BasketViewController: BasketTableViewCellDelegate {
    func deleteButtonClicked(image: UIImage, idNftToDelete: String) {
        setupBlurView()
        deleteCardView.configureView(image: image, idNftToDelete: idNftToDelete)
    }
}

//MARK: - BasketDeleteCardViewDelegate

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

