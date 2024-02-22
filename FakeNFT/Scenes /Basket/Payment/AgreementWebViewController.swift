//
//  AgreementWebViewController.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 22.02.2024.
//

import UIKit
import WebKit

class AgreementWebViewController: UIViewController {
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    private let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        load()
    }
    
    private func load() {
        guard let url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func setupView() {
        webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
    }
}


