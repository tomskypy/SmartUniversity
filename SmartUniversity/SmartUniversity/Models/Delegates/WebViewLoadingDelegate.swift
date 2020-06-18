//
//  WebViewLoadingDelegate.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import WebKit

protocol WebViewLoadingDelegate: WKNavigationDelegate {

    func webViewDidFinishLoading(_ webView: WKWebView)
}

extension WebViewLoadingDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewDidFinishLoading(webView)
    }
}
