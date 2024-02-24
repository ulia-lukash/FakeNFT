//
//  StarRatingView.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 13.02.2024.
//

import Foundation
import UIKit

final class StarRatingView: UIView {

    private lazy var firstStar = UIImageView(image: UIImage(systemName: "star.fill"))
    private lazy var secondStar = UIImageView(image: UIImage(systemName: "star.fill"))
    private lazy var thirdStar = UIImageView(image: UIImage(systemName: "star.fill"))
    private lazy var fourthStar = UIImageView(image: UIImage(systemName: "star.fill"))
    private lazy var fifthStar = UIImageView(image: UIImage(systemName: "star.fill"))
    private var stars: [UIImageView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
       stars = [firstStar, secondStar, thirdStar, fourthStar, fifthStar]

        stars.forEach {
            $0.tintColor = UIColor.segmentInactive
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: 12),
                $0.heightAnchor.constraint(equalToConstant: 12),
                $0.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        }

        NSLayoutConstraint.activate([
            firstStar.topAnchor.constraint(equalTo: self.topAnchor),
            firstStar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            secondStar.leadingAnchor.constraint(equalTo: firstStar.trailingAnchor),
            thirdStar.leadingAnchor.constraint(equalTo: secondStar.trailingAnchor),
            fourthStar.leadingAnchor.constraint(equalTo: thirdStar.trailingAnchor),
            fifthStar.leadingAnchor.constraint(equalTo: fourthStar.trailingAnchor)
        ])
    }

    func setRating(with number: Int) {
        let maxRating = number > 5 ? 5 : number

        for index in 0..<maxRating {
            stars[index].tintColor = UIColor.yellowUniversal
        }
    }
}
