//
//  AgreementWebViewController.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 22.02.2024.
//

import UIKit
import WebKit

class AgreementWebViewController: UIViewController, WKNavigationDelegate, LoadingView {
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    internal lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        load()
    }
    
    private func load() {
        guard let url = url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func setupView() {
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: view)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
