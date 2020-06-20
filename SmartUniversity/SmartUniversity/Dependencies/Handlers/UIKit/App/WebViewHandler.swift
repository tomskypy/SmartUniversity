//
//  WebViewHandler.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 11/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import WebKit

final class WebViewHandler: NSObject, WebViewHandling {

    weak var webView: WKWebView?

    private var completionHandler: CompletionHandler?

    func loadURL(_ url: URL, completion: CompletionHandler?) {
        if let completion = completion {
            completionHandler = completion
            webView?.navigationDelegate = self
        }

        webView?.load(URLRequest(url: url))
    }

    func lockZoomScaleTo(_ zoomScale: CGFloat) {
        guard let webView = webView else { return }

        webView.scrollView.minimumZoomScale = zoomScale
        webView.scrollView.maximumZoomScale = zoomScale

        webView.scrollView.setZoomScale(zoomScale, animated: true)
        webView.scrollView.isScrollEnabled = false
    }
}

extension WebViewHandler: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        completionHandler?()
        completionHandler = nil
    }
}
