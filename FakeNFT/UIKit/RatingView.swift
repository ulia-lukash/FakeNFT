//
//  RatingView.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 24.03.2024.
//

import Foundation
import UIKit
import Cosmos

final class RatingView: CosmosView {
        
        override init(frame: CGRect, settings: CosmosSettings) {
            super.init(frame: frame, settings: settings)
            commonInit()
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        private func commonInit() {
            rating = 0
            settings.starSize = 15
            settings.filledColor = Asset.Colors.yellow.color
            settings.starMargin = 2
            settings.emptyColor = Asset.Colors.lightGray.color
            settings.emptyBorderColor = .clear
            settings.filledBorderColor = .clear
            translatesAutoresizingMaskIntoConstraints = false
        }
}

