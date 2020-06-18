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

final class MunimapViewControllerTests: XCTestCase {

    private var munimapServerURL: URL!
    private var webViewHandler: TestableWebViewHandler!
    private var viewController: MunimapViewController!

    override func setUp() {
        munimapServerURL = URL(string: "https://www.apple.com")!
        webViewHandler = .init()

        viewController = .init(munimapServerURL: munimapServerURL, webViewHandler: webViewHandler)
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
