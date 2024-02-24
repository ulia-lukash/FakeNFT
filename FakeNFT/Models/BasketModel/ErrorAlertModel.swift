//
//  ErrorAlertModel.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 23.02.2024.
//

import Foundation

struct ErrorAlertModel {
    let title: String
    let message: String?
    let actionSheetTextFirst: String
    let actionSheetTextSecond: String
    let completionFirst: () -> Void
    let completionSecond: () -> Void
}
