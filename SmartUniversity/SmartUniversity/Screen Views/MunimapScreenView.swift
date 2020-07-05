//
//  MunimapScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 11/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import WebKit

final class MunimapScreenView: TitledScreenView {

    var isLoadingOverlayHidden: Bool = true {
        didSet {
            if isLoadingOverlayHidden {
                loadingOverlay.removeFromSuperview()
            } else {
                addSubview(loadingOverlay)
            }
        }
    }

    let loadingOverlay = LoadingOverlayView(layoutProvider: AppLayoutProvider.shared)

    let webView = WKWebView()

    override init(layoutProvider: LayoutProviding) {
        super.init(layoutProvider: layoutProvider)

        titleText = "munimap"
        titleColor = .black
    }

    required init?(coder: NSCoder) { nil }

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {

        let contentHeight = bounds.height + safeAreaInsets.verticalSum

        let fullScreenFrame =  CGRect(x: 0, y: -safeAreaInsets.top, width: bounds.width, height: contentHeight)

        return super.frames(forBounds: bounds) + [(webView, fullScreenFrame), (loadingOverlay, fullScreenFrame)]
    }

    override func setupSubviews() {
        addSubview(webView)
    }
}
