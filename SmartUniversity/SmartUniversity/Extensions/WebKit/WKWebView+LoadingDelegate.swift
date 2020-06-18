//
//  WKWebView+LoadingDelegate.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import WebKit

extension WKWebView {

    func setLoadingDelegate(_ delegate: WebViewLoadingDelegate) {
        navigationDelegate = delegate
    }
}
