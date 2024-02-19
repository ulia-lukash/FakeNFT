//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Григорий Машук on 17.02.24.
//

import UIKit

final class MyNFTViewController: UIViewController {
    private enum ConstMyNFTVC: String {
        static let heightCell = CGFloat(140)
        case backwardProfile
        case sortProfile
    }
    
    private lazy var myNFTTable: UITableView = {
        let myNFTTable = UITableView()
        
        return myNFTTable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUIItem()
    }
}

private extension MyNFTViewController {
    func setupUIItem() {
        setupNavigationBar()
        setupMyNFTTable()
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
                                                    action: #selector(rightBarButtonItemTap))
        topItem.leftBarButtonItem?.tintColor = .blackUniversal
        topItem.rightBarButtonItem?.tintColor = .blackUniversal
        navBar.backgroundColor = .clear
        navigationItem.titleView = UILabel()
        topItem.title = ConstLocalizable.profileCellMyNFT
        navigationItem.titleView?.tintColor = .blackUniversal
//        navigationController?.parent?.title = ConstLocalizable.myNFTProfile
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
//        navigationController?.navigationBar.prefersLargeTitles = true
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
        if let firstSubview = alertController.view.subviews.first,
           let alertContentView = firstSubview.subviews.first {
            for view in alertContentView.subviews {
                view.backgroundColor = .grayUniversalWithAlpha
            }
        }
        let actionSortByPrice = UIAlertAction(title: ConstLocalizable.myNFTVCByPrice,
                                              style: .default)
        let actionSortByRating = UIAlertAction(title: ConstLocalizable.myNFTVCByRating,
                                              style: .default)
        let actionSortByName = UIAlertAction(title: ConstLocalizable.myNFTVCByName,
                                              style: .default)
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
}

extension MyNFTViewController: UITableViewDelegate {}

extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ConstMyNFTVC.heightCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(MyNFTTableCell.self)") as? MyNFTTableCell
        else { return UITableViewCell() }
        return cell
    }
}
