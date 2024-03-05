//
//  AlertModel.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 18.02.2024.
//

import Foundation

struct SortAlertModel {
    let title: String
    let message: String?
    let actionSheetTextFirst: String
    let actionSheetTextSecond: String
    let actionSheetTextThird: String
    let actionSheetTextCancel: String
    let completionFirst: () -> Void
    let completionSecond: () -> Void
    let completionThird: () -> Void
}
