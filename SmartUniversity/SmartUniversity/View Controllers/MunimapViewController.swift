//
//  MunimapViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 11/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class MunimapViewController: BaseViewController<MunimapScreenView> {

    private static let mapSize = CGSize(width: 500, height: 1000)

    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }

    let munimapServerURL: URL
    var webViewHandler: WebViewHandling

    init(munimapServerURL: URL, webViewHandler: WebViewHandling) {
        self.munimapServerURL = munimapServerURL
        self.webViewHandler = webViewHandler
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()

        webViewHandler.webView = screenView?.webView
        webViewHandler.loadURL(munimapServerURL) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.lockWebViewZoom()
            }
        }
        screenView?.isLoadingOverlayHidden = false
    }

    private func lockWebViewZoom() {
        let webViewZoomScale = calculateIdealZoomScale(
            viewFrame: view.frame,
            screenScale: UIScreen.main.scale,
            mapSize: Self.mapSize
        )
        webViewHandler.lockZoomScaleTo(webViewZoomScale)

        screenView?.isLoadingOverlayHidden = true
    }

    private func calculateIdealZoomScale(
        viewFrame: CGRect,
        screenScale: CGFloat,
        mapSize: CGSize
    ) -> CGFloat { // TODO move to specific provider

        let xRatio = viewFrame.width * screenScale / mapSize.width
        let yRatio = viewFrame.height * screenScale / mapSize.height

        let scale = max(xRatio, yRatio) / 2

        return scale > 1.1 ? scale : 1
    }
}
