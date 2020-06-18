//
//  MunimapScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 11/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import WebKit

class MunimapScreenView: FrameBasedView {

    let webView = WKWebView()

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {

        let contentHeight = bounds.height + safeAreaInsets.verticalSum

        let webViewFrame = CGRect(x: 0, y: -safeAreaInsets.top, width: bounds.width, height: contentHeight)

        return [(view: webView, frame: webViewFrame)]
    }
}

extension MunimapScreenView: BaseScreenView {

    func setupSubviews() {
        addSubview(webView)
    }
}
