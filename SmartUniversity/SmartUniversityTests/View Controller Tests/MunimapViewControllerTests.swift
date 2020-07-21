//
//  MunimapViewControllerTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 18/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest
import WebKit

@testable import SmartUniversity

private final class TestableWebViewHandler: WebViewHandling {

    var webView: WKWebView?

    var urlReceivedInLoadURL: URL?

    func loadURL(_ url: URL, completion: CompletionHandler?) {
        urlReceivedInLoadURL = url
    }

    func lockZoomScaleTo(_ zoomScale: CGFloat) { }
}

private final class TestableMapScaleProvider: MunimapScaleProviding {

    func mapZoomScale(forViewFrame viewFrame: CGRect, mapSize: CGSize) -> CGFloat {
        return 0
    }
}

final class MunimapViewControllerTests: XCTestCase {

    private var munimapServerURL: URL!
    private var webViewHandler: TestableWebViewHandler!
    private var mapScaleProvider: TestableMapScaleProvider!

    private var viewController: MunimapViewController!

    override func setUp() {
        munimapServerURL = URL(string: "https://www.apple.com")!
        webViewHandler = .init()
        mapScaleProvider = .init()

        viewController = .init(
            munimapServerURL: munimapServerURL,
            webViewHandler: webViewHandler,
            mapScaleProvider: mapScaleProvider
        )
    }

    func testViewDidLoadSetsWebViewOnWebViewHandler() {
        viewController.viewDidLoad()

        XCTAssertNotNil(webViewHandler.webView)
    }

    func testViewDidLoadCallsLoadURLWithProvidedServerURL() {
        let expectedURL = munimapServerURL

        viewController.viewDidLoad()

        XCTAssertEqual(expectedURL, webViewHandler.urlReceivedInLoadURL)
    }
}
