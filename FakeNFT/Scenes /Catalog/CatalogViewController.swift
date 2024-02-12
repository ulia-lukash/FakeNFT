//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 11.02.2024.
//

import Foundation
import UIKit

final class CatalogViewController: UIViewController {

    
    private lazy var burgerButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "text.justify.leading")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.segmentActive
        button.addTarget(self, action: #selector(didPressBurgerButton), for: .touchUpInside)
        return button
    }()

    private lazy var nftCollection: UITableView = {
        let collection = UITableView()
        collection.register(CatalogTableViewCell.self)
        collection.register(CatalogTableFooterView.self)
        collection.separatorStyle = .none
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        nftCollection.dataSource = self
        nftCollection.delegate = self
        setUp()
    }

    private func setUp() {
        view.backgroundColor = .systemBackground
        [burgerButton, nftCollection].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            burgerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            burgerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            burgerButton.widthAnchor.constraint(equalToConstant: 42),
            burgerButton.heightAnchor.constraint(equalToConstant: 42),
            nftCollection.topAnchor.constraint(equalTo: burgerButton.bottomAnchor, constant: 20),
            nftCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private var mockCollections: [NftCollection] = [
        NftCollection(createdAt: "2023-04-20T02:22:27Z", name: "Beige", cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/ÐžÐ±Ð»Ð¾Ð¶ÐºÐ¸_ÐºÐ¾Ð»Ð»ÐµÐºÑ†Ð¸Ð¹/Beige.png", nfts: [
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10",
            "11",
            "12",
            "13",
            "14",
            "15",
            "16",
            "17",
            "18",
            "19",
            "20",
            "21"
        ], description: "A series of one-of-a-kind NFTs featuring historic moments in sports history.", author: "6", id: "1"),
        NftCollection(createdAt: "2023-04-20T02:22:27Z",
                      name: "Blue",
                      cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/ÐžÐ±Ð»Ð¾Ð¶ÐºÐ¸_ÐºÐ¾Ð»Ð»ÐµÐºÑ†Ð¸Ð¹/Blue.png",
                      nfts: [
                        "22",
                        "23",
                        "24",
                        "25",
                        "26"
                      ],
                      description: "A collection of virtual trading cards featuring popular characters from movies and TV shows.",
                      author: "9",
                      id: "2"),
        NftCollection(
            createdAt: "2023-04-20T02:22:27Z",
            name: "Gray",
            cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/ÐžÐ±Ð»Ð¾Ð¶ÐºÐ¸_ÐºÐ¾Ð»Ð»ÐµÐºÑ†Ð¸Ð¹/Gray.png",
            nfts: [
                "27",
                "28",
                "29",
                "30",
                "31",
                "32",
                "33",
                "34",
                "35",
                "36",
                "37",
                "38",
                "39",
                "40",
                "41",
                "42",
                "43",
                "44",
                "45"
            ],
            description: "A set of limited edition digital stamps featuring famous landmarks from around the world.",
            author: "12",
            id: "3"),
        NftCollection(createdAt: "2023-04-20T02:22:27Z",
                      name: "Green",
                      cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/ÐžÐ±Ð»Ð¾Ð¶ÐºÐ¸_ÐºÐ¾Ð»Ð»ÐµÐºÑ†Ð¸Ð¹/Green.png",
                      nfts: [
                        "46",
                        "47",
                        "48"
                      ],
                      description: "A collection of unique 3D sculptures that can be displayed in virtual reality.",
                      author: "15",
                      id: "4"),
        NftCollection(createdAt: "2023-04-20T02:22:27Z",
                      name: "Peach",
                      cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/ÐžÐ±Ð»Ð¾Ð¶ÐºÐ¸_ÐºÐ¾Ð»Ð»ÐµÐºÑ†Ð¸Ð¹/Peach.png",
                      nfts: [
                        "49",
                        "50",
                        "51",
                        "52",
                        "53",
                        "54",
                        "55",
                        "56",
                        "57",
                        "58",
                        "59"
                      ],
                      description: "A series of NFTs featuring original music compositions from up-and-coming musicians.",
                      author: "18",
                      id: "5"),
        NftCollection(createdAt: "2023-04-20T02:22:27Z",
                      name: "Pink",
                      cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/ÐžÐ±Ð»Ð¾Ð¶ÐºÐ¸_ÐºÐ¾Ð»Ð»ÐµÐºÑ†Ð¸Ð¹/Pink.png",
                      nfts: [
                        "60",
                        "61",
                        "62",
                        "63",
                        "64",
                        "65",
                        "66",
                        "67",
                        "68",
                        "69",
                        "70",
                        "71",
                        "72",
                        "73"
                      ],
                      description: "A collection of virtual clothing items that can be worn in online games and social networks.",
                      author: "21",
                      id: "6"),
        NftCollection(createdAt: "2023-04-20T02:22:27Z",
                      name: "White",
                      cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/ÐžÐ±Ð»Ð¾Ð¶ÐºÐ¸_ÐºÐ¾Ð»Ð»ÐµÐºÑ†Ð¸Ð¹/White.png",
                      nfts: [
                        "74",
                        "75",
                        "76",
                        "77",
                        "78",
                        "79",
                        "80"
                      ],
                      description: "A set of rare NFTs featuring the work of famous street artists from around the world.",
                      author: "24",
                      id: "7"),
        NftCollection(createdAt: "2023-04-20T02:22:27Z",
                      name: "Yellow",
                      cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/ÐžÐ±Ð»Ð¾Ð¶ÐºÐ¸_ÐºÐ¾Ð»Ð»ÐµÐºÑ†Ð¸Ð¹/Yellow.png",
                      nfts: [
                        "81",
                        "82",
                        "83",
                        "84",
                        "85",
                        "86",
                        "87",
                        "88"
                      ],
                      description: "A series of digital pet NFTs that can be raised and trained in a virtual world.",
                      author: "27",
                      id: "8"),
        NftCollection(createdAt: "2023-04-20T02:22:27Z",
                      name: "Brown",
                      cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/ÐžÐ±Ð»Ð¾Ð¶ÐºÐ¸_ÐºÐ¾Ð»Ð»ÐµÐºÑ†Ð¸Ð¹/Brown.png",
                      nfts: [
                        "89",
                        "90",
                        "91",
                        "92",
                        "93",
                        "94",
                        "95"
                      ],
                      description: "A collection of limited edition NFTs featuring the work of world-renowned photographers.",
                      author: "30",
                      id: "9")
    ]

    private func filterByName() {
        mockCollections.sort(by: {$0.name < $1.name})
        self.nftCollection.reloadData()
    }

    private func filterByNumber() {
        mockCollections.sort(by: {$0.nfts.count < $1.nfts.count})
        self.nftCollection.reloadData()
    }

    @objc private func didPressBurgerButton() {
        // TODO: Add localized strings

        let alert = UIAlertController(title: nil, message: NSLocalizedString("Catalog.sort", comment: ""), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Catalog.sort.byName", comment: ""), style: .default, handler: {_ in
            self.filterByName()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Catalog.sort.byNftNumber", comment: ""), style: .default, handler: {_ in
            self.filterByNumber()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}

extension CatalogViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        mockCollections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as CatalogTableViewCell
        let collection = mockCollections[indexPath.section]
        cell.configure(for: collection.name)
        return cell
    }
}

extension CatalogViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let collection = mockCollections[section]
        let name = collection.name
        let count = collection.nfts.count
        let footerString = "\(name) (\(count))"

        let footerView = tableView.dequeueReusableHeaderFooterView() as CatalogTableFooterView
        footerView.configure(labelText: footerString)
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
}
