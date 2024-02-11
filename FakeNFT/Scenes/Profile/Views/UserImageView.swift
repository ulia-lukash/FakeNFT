//
//  UserImageView.swift
//  FakeNFT
//
//  Created by Григорий Машук on 10.02.24.
//

import UIKit
import Kingfisher

final class UserImageView: UIImageView {
    private enum Constants: String {
        static let size = CGSize(width: 70, height: 70)
        case placeholderUser
    }
    override init(image: UIImage?) {
        super.init(image: image)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(image: nil)
    }
}

extension UserImageView {
    private func setup() {
        frame = CGRect(origin: .zero, size: Constants.size)
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
    }
    
    func config(with model: UserImageModel) {
        kf.setImage(with: model.url, placeholder: UIImage(named: Constants.placeholderUser.rawValue))
    }
}
