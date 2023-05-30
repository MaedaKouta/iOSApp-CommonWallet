//
//  WebViewController.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/05/31.
//

import UIKit
import WebKit
import PKHUD

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    private let url: URL
    @IBOutlet private weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        webView.uiDelegate = self

        HUD.show(.progress, onView: view)
        self.webView.load(URLRequest(url: url))
    }

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("読み込み開始")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("読み込み完了")
        HUD.hide(animated: true)
    }

}
