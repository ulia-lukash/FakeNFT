//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 22.02.2024.
//

import UIKit
final class PaymentViewController: UIViewController {
    
    // MARK: - Private properties:
    
    private let collectionSettings = CollectionSettings(
        cellCount: 2,
        top: 0,
        bottom: 0,
        left: 16,
        right: 16,
        cellSpacing: 7
    )
    
    // MARK: - UI
    
    private lazy var bottomView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.segmentInactive
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var paymentButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = UIColor.segmentActive
        button.tintColor = UIColor.whiteModeThemes
        button.setTitle("Оплатить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stubLabel: UILabel = {
        var label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.textColor = UIColor.segmentActive
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var agreementButton: UIButton = {
        var button = UIButton(type: .system)
        button.tintColor = UIColor.blueUniversal
        button.setTitle("Пользовательского соглашения", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var paymentCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(
            PaymentCollectionCell.self,
            forCellWithReuseIdentifier: PaymentCollectionCell.identifier
        )
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Initializers
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        setupConstraints()
        setupNavBar()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.addSubview(bottomView)
        view.addSubview(paymentCollectionView)
        view.addSubview(paymentButton)
        view.addSubview(stubLabel)
        view.addSubview(agreementButton)
    }
    
    private func setupNavBar() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "chevronBasket"), style: .plain, target: self, action:#selector(chevronDidTap))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.segmentActive
        self.navigationItem.title = "Выберите способ оплаты"
        let textChangeColor = [NSAttributedString.Key.foregroundColor: UIColor.segmentActive]
        self.navigationController?.navigationBar.titleTextAttributes = textChangeColor
        self.navigationController?.navigationBar.largeTitleTextAttributes = textChangeColor
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 186),
            
            paymentCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            paymentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentCollectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            paymentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            paymentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            paymentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            paymentButton.heightAnchor.constraint(equalToConstant: 60),
            
            stubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stubLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            
            agreementButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            agreementButton.topAnchor.constraint(equalTo: stubLabel.bottomAnchor, constant: 4),
        ])
    }
    
    @objc private func chevronDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapPayButton() {
        //
    }
    
    @objc private func openWebView() {
        let viewController = AgreementWebViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout:

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - collectionSettings.paddingWidth
        let cellWidth =  availableWidth / CGFloat(collectionSettings.cellCount)
        return CGSize(width: cellWidth, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionSettings.top, left: collectionSettings.left, bottom: collectionSettings.bottom, right: collectionSettings.right)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionSettings.cellSpacing
    }
}

// MARK: - UICollectionViewDataSource:

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        PaymentModel.mocksPayment.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentCollectionCell.identifier, for: indexPath) as? PaymentCollectionCell else { return UICollectionViewCell()}
        cell.cellSettings(for: PaymentModel.mocksPayment[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate:

extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PaymentCollectionCell else { return }
        cell.isSelected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({ collectionView.deselectItem(at: $0, animated: false) })
        return true
    }
}
