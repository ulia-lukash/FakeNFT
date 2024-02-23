//
//  AuthorWebViewViewModel.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 17.02.2024.
//

import Foundation

protocol AuthorViewModelProtocol: AnyObject {
    var webViewUrl: URL? { get }
    func setUrl(_ url: URL)
}

final class AuthorWebViewViewModel: AuthorViewModelProtocol {
    private(set) var webViewUrl: URL?

    func setUrl(_ url: URL) {
        self.webViewUrl = url
    }
}
