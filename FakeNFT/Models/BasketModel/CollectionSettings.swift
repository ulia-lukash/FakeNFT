//
//  CollectionSettings.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 22.02.2024.
//

import Foundation

struct CollectionSettings {
    let cellCount: Int
    let top: CGFloat
    let bottom: CGFloat
    let left: CGFloat
    let right: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat

    init(
        cellCount: Int,
        top: CGFloat,
        bottom: CGFloat,
        left: CGFloat,
        right: CGFloat,
        cellSpacing: CGFloat
    ) {
        self.cellCount = cellCount
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right
        self.cellSpacing = cellSpacing
        self.paddingWidth = left + right + CGFloat(cellCount - 1) * cellSpacing
    }
}
