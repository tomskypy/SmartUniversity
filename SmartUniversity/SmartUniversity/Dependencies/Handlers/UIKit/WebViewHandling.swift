//
//  WebViewHandling.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import WebKit

protocol WebViewHandling {

    var webView: WKWebView? { get set }

    func loadURL(_ url: URL)
    func lockZoomScaleTo(_ zoomScale: CGFloat)
}
