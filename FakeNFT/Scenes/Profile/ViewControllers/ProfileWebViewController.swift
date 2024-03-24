//
//  ProfileWebViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 22.06.23.
//

import UIKit
import WebKit

// MARK: - ProfileWebViewController
final class ProfileWebViewController: UIViewController, LoadingView {
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .clear
        
        return webView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = Asset.Colors.black.color
        
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.white.color
        setupUiItems()
    }
}

extension ProfileWebViewController {
    // MARK: - func
    
    private func setupUiItems() {
        setupNavigationBar()
        addSubViews()
        setupConstraint()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = Asset.Colors.black.color
    }
    
    private func isUserInterecrion(flag: Bool) {
        flag ? self.hideLoading() : self.showLoading()
        self.navigationController?.navigationBar.isUserInteractionEnabled = flag
    }
    
    private func addSubViews() {
        [webView, activityIndicator].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraint() {
        activityIndicator.constraintCenters(to: view)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func showIndicator() {
        isUserInterecrion(flag: false)
    }
}

// MARK: - WKNavigationDelegate
extension ProfileWebViewController: WKNavigationDelegate {    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isUserInterecrion(flag: true)
    }
}
