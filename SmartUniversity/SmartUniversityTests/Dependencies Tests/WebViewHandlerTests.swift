//
//  WebViewHandlerTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 18/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest
import WebKit

@testable import SmartUniversity

private final class TestableWebView: WKWebView {

    var urlRequestReceivedInLoad: URLRequest?

    override func load(_ request: URLRequest) -> WKNavigation? {
        urlRequestReceivedInLoad = request

        return nil
    }

    func triggerWebViewDidFinish() {

        navigationDelegate!.webView!(self, didFinish: nil)
    }
}

final class WebViewHandlerTests: XCTestCase {

    private static let testableURL = URL(string: "https://www.apple.com")!

    private var webViewHandler: WebViewHandler!

    override func setUp() {
        webViewHandler = .init()
    }

    func testLoadURLCallsLoadCorrectlyOnAssignedWebView() {
        let webView = TestableWebView()
        let expectedURL = Self.testableURL

        webViewHandler.webView = webView
        webViewHandler.loadURL(expectedURL)

        XCTAssertEqual(expectedURL, webView.urlRequestReceivedInLoad?.url)
    }

    func testLoadURLTriggersCompletionWhenWebViewDidFinish() {
        let webView = TestableWebView()
        var didTriggerCompletion = false

        webViewHandler.webView = webView
        webViewHandler.loadURL(Self.testableURL, completion: {
            didTriggerCompletion = true
        })

        webView.triggerWebViewDidFinish()

        XCTAssertTrue(didTriggerCompletion)
    }
}
