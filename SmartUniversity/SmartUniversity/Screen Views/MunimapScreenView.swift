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
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    self.loadingOverlay.alpha = 0.0
                }, completion: { _ in
                    self.loadingOverlay.removeFromSuperview()
                })
            } else {
                loadingOverlay.alpha = 1.0
                addSubview(loadingOverlay)
            }
        }
    }

    let webView = WKWebView()

    private lazy var loadingOverlay = LoadingOverlayView(
        loadingText: "loading map",
        colorProvider: colorProvider,
        layoutProvider: layoutProvider
    )

    private let colorProvider: ColorProviding

    init(colorProvider: ColorProviding, layoutProvider: LayoutProviding) {
        self.colorProvider = colorProvider
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
