//
//  AuthorWebViewViewModel.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 17.02.2024.
//

import Foundation

final class AuthorWebViewViewModel {
    private(set) var webViewUrl: URL?

    func setUrl(_ url: URL) {
        self.webViewUrl = url
    }
}
