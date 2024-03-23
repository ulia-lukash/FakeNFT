//
//  ProfileTableViewCell.swift
//  FakeNFT
//
//  Created by Григорий Машук on 10.02.24.
//

import Foundation
import UIKit

// MARK: - ProfileTableViewCell
final class ProfileTableViewCell: UITableViewCell, ReuseIdentifying {

    private lazy var myNFTLabel: UILabel = {
        let myNFTLabel = UILabel()
        myNFTLabel.textColor = Asset.Colors.black.color
        myNFTLabel.font = .bodyBold
        
        return myNFTLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
        accessoryView?.tintColor = Asset.Colors.black.color
        setupUIItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - extension
extension ProfileTableViewCell {
    private func setupUIItem() {
        addSubview(myNFTLabel)
        myNFTLabel.translatesAutoresizingMaskIntoConstraints = false
        myNFTLabel.backgroundColor = .clear
        myNFTLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        myNFTLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func config(with cellModel: ProfileCellModel) {
        myNFTLabel.text = cellModel.text
    }
}
