import UIKit
import WebKit

final class IPFHelpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TestHelper.title".localized

        if let helpFileURL = Bundle.main.url(forResource: "Help", withExtension: "html") {
            webview.loadFileURL(helpFileURL, allowingReadAccessTo: helpFileURL)
        }

        view = webview
    }

    private lazy var webview: WKWebView = {
        $0.allowsLinkPreview = false
        $0.navigationDelegate = self
        return $0
    }(WKWebView(frame: .zero))
}

extension IPFHelpViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }

        if url.isFileURL {
            // Local file load
            decisionHandler(.allow)
        } else {
            // Tap on a link, open Safari
            decisionHandler(.cancel)
            DispatchQueue.main.async {
                UIApplication.shared.openURL(url)
            }
        }
    }

}
