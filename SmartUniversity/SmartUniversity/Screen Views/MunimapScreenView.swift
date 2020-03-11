//
//  MunimapScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 11/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit
import WebKit

class MunimapScreenView: FrameBasedScreenView {

    let webView: WKWebView = WKWebView()

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {

        let webViewFrame = CGRect(
            origin: CGPoint(x: 0, y: -safeAreaInsets.top),
            size: .init(width: bounds.width, height: bounds.height + safeAreaInsets.top + safeAreaInsets.bottom))

        return [(view: webView, frame: webViewFrame)]
    }
}

extension MunimapScreenView: BaseScreenView {

    func setupSubviews() {
        self.addSubview(webView)
    }
}
