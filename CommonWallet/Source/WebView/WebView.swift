//
//  WebView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/05/19.
//

import SwiftUI
import WebKit

struct WebView: View {

    let url: URL

    var body: some View {
        WebViewControllerWrapper(url: url) {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }.ignoresSafeArea()
    }

}

struct WebViewControllerWrapper<Content: View>: UIViewControllerRepresentable {

    let url: URL
    typealias UIViewControllerType = WebViewController
    var content: () -> Content

    func makeUIViewController(context: Context) -> WebViewController {
        let viewControllerWithStoryboard = WebViewController(url: url)
        return viewControllerWithStoryboard
    }

    func updateUIViewController(_ uiviewController: WebViewController, context: Context) {
    }

}
