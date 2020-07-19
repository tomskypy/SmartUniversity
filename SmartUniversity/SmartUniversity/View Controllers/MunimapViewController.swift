//
//  MunimapViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 11/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class MunimapViewController: BaseViewController<MunimapScreenView> {

    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }

    let munimapServerURL: URL
    let mapScaleProvider: MunimapScaleProviding

    var webViewHandler: WebViewHandling

    private var isVisible: Bool {
        isViewLoaded && view.window != nil
    }

    private var didLoadMap: Bool = false

    private static let mapSize = CGSize(width: 500, height: 1000)

    init(munimapServerURL: URL, webViewHandler: WebViewHandling, mapScaleProvider: MunimapScaleProviding) {
        self.munimapServerURL = munimapServerURL
        self.webViewHandler = webViewHandler
        self.mapScaleProvider = mapScaleProvider

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()

        webViewHandler.webView = screenView?.webView
        webViewHandler.loadURL(munimapServerURL) { [weak self] in
            self?.didLoadMap = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.hideLoadingAndLockWebViewZoom()
            }
        }
        screenView?.isLoadingOverlayHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let isShowingLoadingOverlay = screenView?.isLoadingOverlayHidden == false
        if didLoadMap && isShowingLoadingOverlay {
            hideLoadingAndLockWebViewZoom()
        }
    }

    private func hideLoadingAndLockWebViewZoom() {
        guard isVisible else { return }

        let webViewZoomScale = mapScaleProvider.mapZoomScale(forViewFrame: view.frame, mapSize: Self.mapSize)
        webViewHandler.lockZoomScaleTo(webViewZoomScale)

        screenView?.isLoadingOverlayHidden = true
    }
}
