//
//  WebViewHandling.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import WebKit

protocol WebViewHandling {
    typealias CompletionHandler = () -> Void

    var webView: WKWebView? { get set }

    func loadURL(_ url: URL, completion: CompletionHandler?)
    func lockZoomScaleTo(_ zoomScale: CGFloat)
}

extension WebViewHandling {

    func loadURL(_ url: URL) {
        loadURL(url, completion: nil)
    }
}
