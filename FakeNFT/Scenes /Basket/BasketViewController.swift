//
//  BasketViewController.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 09.02.2024.
//

import UIKit

final class BasketViewController: UIViewController {
    
    let servicesAssembly: ServicesAssembly
    var counterNft: Int = 0
    var quantityNft: Double = 0
    
    // MARK: - UI
    
    private var bottomView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.segmentInactive
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var paymentButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = UIColor.segmentActive
        button.tintColor = UIColor.whiteModeThemes
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var quantityNftLabel: UILabel = {
        var label = UILabel()
        label.text = "\(counterNft) NFT"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var amountNftLabel: UILabel = {
        var label = UILabel()
        label.text = "\(quantityNft) ETH"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.greenUniversal
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var stubLabel: UILabel = {
        var label = UILabel()
        label.text = "Корзина пуста"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isMultipleTouchEnabled = false
        scroll.isScrollEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.decelerationRate = .init(rawValue: 1)
        return scroll
    }()
    
    // MARK: - Initializers
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
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
        
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.addSubview(scrollView)
        view.addSubview(bottomView)
        view.addSubview(quantityNftLabel)
        view.addSubview(amountNftLabel)
        view.addSubview(paymentButton)
        scrollView.addSubview(tableView)
       // view.addSubview(stubLabel)
    }
    
    private func setupConstraints() {
        
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
            
            quantityNftLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            quantityNftLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            quantityNftLabel.bottomAnchor.constraint(equalTo: amountNftLabel.topAnchor, constant: -2),
            
            amountNftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            amountNftLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
            
            paymentButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            paymentButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
            paymentButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            paymentButton.leadingAnchor.constraint(equalTo: amountNftLabel.trailingAnchor, constant: 24)
            
//            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            stubLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
    
    private func navBarItem() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.largeTitleDisplayMode = .always
        
        let rightButton = UIBarButtonItem(
            image: UIImage(named: "Sort"),
            style: .plain,
            target: self,
            action: #selector(didTapSortButton)
        )
        rightButton.tintColor = UIColor.segmentActive
        navigationItem.rightBarButtonItem = rightButton
        
    }
    
    @objc private func didTapSortButton() {
        //TODO
    }
    
    @objc private func didTapPayButton() {
        //TODO
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
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketTableViewCell.identifier) as? BasketTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}
