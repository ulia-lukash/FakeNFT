//
//  ProfileTableViewCell.swift
//  FakeNFT
//
//  Created by Григорий Машук on 10.02.24.
//

import Foundation
import UIKit

final class ProfileTableViewCell: UITableViewCell {
    private let count: Int = 0
    
    private lazy var myNFTLabel: UILabel = {
        let myNFTLabel = UILabel()
        myNFTLabel.font = .bodyBold
        
        return myNFTLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUIItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProfileTableViewCell {
    func setupUIItem() {
    }
}
