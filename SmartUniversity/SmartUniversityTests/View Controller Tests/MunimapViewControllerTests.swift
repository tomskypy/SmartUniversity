//
//  MunimapViewControllerTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 18/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest
import WebKit

private final class TestableWebViewHandler: WebViewHandling {

    var webView: WKWebView? = nil

    var urlReceivedInLoadURL: URL? = nil

    func loadURL(_ url: URL) {
        urlReceivedInLoadURL = url
    }

}

final class MunimapViewControllerTests: XCTestCase {

    private var munimapServerURL: URL!
    private var webViewHandler: TestableWebViewHandler!
    private var viewController: MunimapViewController!

    override func setUp() {
        munimapServerURL = URL(string: "https://www.apple.com")!
        webViewHandler = TestableWebViewHandler()

        viewController = MunimapViewController(munimapServerURL: munimapServerURL, webViewHandler: webViewHandler)
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
