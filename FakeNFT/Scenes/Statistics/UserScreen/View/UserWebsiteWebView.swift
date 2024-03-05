import UIKit
import WebKit


class WebViewViewController: UIViewController, WKUIDelegate {
    private var webView: WKWebView!

    var userWebsite: URL? = URL(string: "https://practicum.yandex.ru/")

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = userWebsite else {
            return
        }

        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
}
