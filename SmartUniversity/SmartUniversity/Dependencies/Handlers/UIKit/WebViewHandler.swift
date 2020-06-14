//
//  WebViewHandler.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 11/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import WebKit

protocol WebViewHandling {

    var webView: WKWebView? { get set }

    func loadURL(_ url: URL)
    func lockZoomScaleTo(_ zoomScale: CGFloat)
}

class WebViewHandler: WebViewHandling {

    static var shared = WebViewHandler()

    weak var webView: WKWebView?

    func loadURL(_ url: URL) {
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
