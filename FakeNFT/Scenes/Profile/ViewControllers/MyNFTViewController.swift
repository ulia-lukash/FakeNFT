//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Григорий Машук on 17.02.24.
//

import UIKit

final class MyNFTViewController: UIViewController, ErrorView, LoadingView  {
    private enum ConstMyNFTVC: String {
        static let heightCell = CGFloat(140)
        case backwardProfile
        case sortProfile
    }
    
    internal lazy var activityIndicator = UIActivityIndicatorView()
    private let viewModel: MyNftViewModelProtocol
    
    private lazy var myNFTTable: UITableView = {
        let myNFTTable = UITableView()
        
        return myNFTTable
    }()
    
    private lazy var empryNftLabel: UILabel = {
        let empryNftLabel = UILabel()
        
        return empryNftLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
        setupUIItem()
    }
    
    init(viewModel: MyNftViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MyNFTViewController {
    func bind() {
        guard let viewModel = viewModel as? MyNftViewModel else { return }
        viewModel.$state.bind { [weak self] state in
            guard let self else { return }
            switch state {
            case .initial:
                assertionFailure("can't move to initial state")
            case .loading:
                if viewModel.flagDownload {
                    view.isUserInteractionEnabled = false
                    self.showLoading()
                }
            case .update:
                break
            case .failed(let error):
                let errorModel = viewModel.makeErrorModel(error: error)
                self.showError(errorModel)
            case .data(_):
                updateMyTableView()
                self.hideLoading()
                view.isUserInteractionEnabled = true
            }
        }
        
        viewModel.$sortState.bind { _ in
            viewModel.sort()
        }
    }
    
    func updateMyTableView() {
        if viewModel.getListMyNft().count == ApiConstants.pageSize {
            myNFTTable.reloadData()
        } else {
            myNFTTable.performBatchUpdates { [weak self] in
                guard let self else { return }
                self.myNFTTable.insertRows(at: self.viewModel.getIndexPaths(),
                                           with: .automatic)
            }
        }
    }
    
    func setupUIItem() {
        setupNavigationBar()
        setupMyNFTTable()
        setupActivitiIndicator()
    }
    
    func setupNavigationBar() {
        guard let navBar = navigationController?.navigationBar,
              let topItem = navBar.topItem
        else { return }
        
        topItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: ConstMyNFTVC.sortProfile.rawValue),
                                                     style: .plain, target: self,
                                                     action: #selector(rightBarButtonItemTap))
        topItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: ConstMyNFTVC.backwardProfile.rawValue),
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
    
    @objc
    func rightBarButtonItemTap() {
        present(createAlert(), animated: true)
    }
    
    @objc
    func leftBarButtonItemTap() {
        dismiss(animated: true)
    }
    
    func createAlert() -> UIAlertController {
        let alertController = UIAlertController(title: ConstLocalizable.myNFTVCSortName,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let actionSortByPrice = UIAlertAction(title: ConstLocalizable.myNFTVCByPrice,
                                              style: .default) { [weak self] _ in
            guard let self else { return }
            actionAlert(state: .price)
        }
        let actionSortByRating = UIAlertAction(title: ConstLocalizable.myNFTVCByRating,
                                               style: .default) { [weak self] _ in
            guard let self else { return }
            actionAlert(state: .rating)
            
        }
        let actionSortByName = UIAlertAction(title: ConstLocalizable.myNFTVCByName,
                                             style: .default) { [weak self] _ in
            guard let self else { return }
            actionAlert(state: .name)
            
        }
        let actionClose = UIAlertAction(title: ConstLocalizable.myNFTVCClose,
                                        style: .cancel)
        [actionSortByPrice,
         actionSortByRating,
         actionSortByName,
         actionClose].forEach {
            alertController.addAction($0)
        }
        
        return alertController
    }
    
    func actionAlert(state: SortState) {
        self.viewModel.reset()
        self.viewModel.setSortState(state: state)
    }
    
    func setupMyNFTTable() {
        view.addSubview(myNFTTable)
        myNFTTable.dataSource = self
        myNFTTable.delegate = self
        myNFTTable.translatesAutoresizingMaskIntoConstraints = false
        myNFTTable.backgroundColor = .clear
        myNFTTable.separatorColor = .clear
        myNFTTable.register(MyNFTTableCell.self,
                            forCellReuseIdentifier: "\(MyNFTTableCell.self)")
        NSLayoutConstraint.activate([
            myNFTTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myNFTTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myNFTTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myNFTTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupEmptyLabel() {
        view.addSubview(empryNftLabel)
        empryNftLabel.translatesAutoresizingMaskIntoConstraints = false
        empryNftLabel.backgroundColor = .blackUniversal
        empryNftLabel.font = .bodyBold
        empryNftLabel.text = ConstLocalizable.myNftVCEmpty
        empryNftLabel.center = view.center
    }
    
    func setupActivitiIndicator() {
        activityIndicator.color = .blackUniversal
        view.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: view)
    }
}

extension MyNFTViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel as? MyNftViewModel else { return }
        if indexPath.row + 1 == viewModel.getListMyNft().count {
            viewModel.sort()
        }
        if !viewModel.flagDownload {
            //TODO: -
            hideLoading()
            view.isUserInteractionEnabled = true
        }
    }
}

extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getListMyNft().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ConstMyNFTVC.heightCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(MyNFTTableCell.self)") as? MyNFTTableCell
        else {
            return UITableViewCell() }
        guard let viewModel = viewModel as? MyNftViewModel else { return UITableViewCell() }
        if viewModel.flagDownload && !viewModel.getListMyNft().isEmpty {
            cell.config(model: viewModel.getListMyNft()[indexPath.row])
        }
        return cell
    }
}
