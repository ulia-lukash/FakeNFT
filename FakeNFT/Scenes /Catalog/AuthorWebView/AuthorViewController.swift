//
//  AuthorViewController.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 14.02.2024.
//

import Foundation
import UIKit
import WebKit

final class AuthorViewController: UIViewController, WKUIDelegate {

    // MARK: - Public Properties

    var viewModel: AuthorViewModelProtocol?

    // MARK: - Private Properties

    private var webView: WKWebView!

    private lazy var progressView = UIProgressView(progressViewStyle: .bar)

    private lazy var backButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "chevron.left"),
        style: .plain,
        target: self,
        action: #selector(backButtonTapped)
    )

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        setUp()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }

    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    // MARK: - Private Methods

    private func updateProgress() {
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }

    private func configureWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        let myURL = viewModel?.webViewUrl
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        updateProgress()

    }

    private func setUp() {
        progressView.progressTintColor = UIColor.segmentActive
        backButtonItem.tintColor = UIColor.segmentActive
        navigationItem.leftBarButtonItem = backButtonItem
        view.backgroundColor = UIColor.whiteModeThemes
        [progressView, webView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
}
