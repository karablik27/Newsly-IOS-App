import UIKit
import WebKit

class ArticleDetailViewController: UIViewController {
    private let webView = WKWebView()
    private let url: URL

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(webView)
        webView.frame = view.bounds
        webView.load(URLRequest(url: url))
        webView.backgroundColor = .black
    }
}
