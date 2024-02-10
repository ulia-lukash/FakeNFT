//
//  ProfileTableViewCell.swift
//  FakeNFT
//
//  Created by Григорий Машук on 10.02.24.
//

import Foundation
import UIKit

final class ProfileTableViewCell: UITableViewCell {
    private lazy var myNFTLabel: UILabel = {
        let myNFTLabel = UILabel()
        myNFTLabel.font = .bodyBold
        // TODO: - delete
        myNFTLabel.text = ConstLocalizable.profileCellMyNFT + "\(10)"
        
        return myNFTLabel
    }()
    
    private lazy var selectImageView: UIImageView = {
        let selectImageView = UIImageView()
        selectImageView.image = UIImage(named: "chevron.forward")
        
        return selectImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - extension
extension ProfileTableViewCell {
    private func setupUIItem() {
        [myNFTLabel, selectImageView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
        NSLayoutConstraint.activate([
            myNFTLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            myNFTLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            selectImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func config(with cellModel: ProfileCellModel) {
        myNFTLabel.text = cellModel.text
    }
}
