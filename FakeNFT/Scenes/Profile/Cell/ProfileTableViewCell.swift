//
//  ProfileTableViewCell.swift
//  FakeNFT
//
//  Created by Григорий Машук on 10.02.24.
//

import Foundation
import UIKit

final class ProfileTableViewCell: UITableViewCell {
    private enum ConstansCell {
        static let selectImage = UIImage(named: "chevron.forward")
    }
    private lazy var myNFTLabel: UILabel = {
        let myNFTLabel = UILabel()
        myNFTLabel.textColor = .blackUniversal
        myNFTLabel.font = .bodyBold
        
        return myNFTLabel
    }()
    
    private lazy var selectImageView: UIImageView = {
        let selectImageView = UIImageView()
        selectImageView.image = ConstansCell.selectImage
        
        return selectImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
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
            myNFTLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            selectImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectImageView.heightAnchor.constraint(equalToConstant: 13.86),
            selectImageView.widthAnchor.constraint(equalToConstant: 7.98)
        ])
    }
    
    func config(with cellModel: ProfileCellModel) {
        myNFTLabel.text = cellModel.text
    }
}
