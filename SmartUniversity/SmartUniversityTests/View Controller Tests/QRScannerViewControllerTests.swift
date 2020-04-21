//
//  QRScannerViewControllerTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 21/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest
import AVFoundation

private final class TestableCaptureSessionHandler: CaptureSessionHandling {

    var delegate: CaptureSessionHandlerDelegate? {
        didSet {
            didSetDelegate = delegate != nil
        }
    }

    var didSetDelegate: Bool? = nil

    var viewReceivedInViewDidLoad: UIView? = nil
    var viewReceivedInViewWillAppear: UIView? = nil
    var viewReceivedInViewWillDisappear: UIView? = nil

    func handleViewDidLoad(_ view: UIView) {
        viewReceivedInViewDidLoad = view
    }

    func handleViewWillAppear(_ view: UIView) {
        viewReceivedInViewWillAppear = view
    }

    func handleViewWillDisappear(_ view: UIView) {
        viewReceivedInViewWillDisappear = view
    }

}

private final class TestableQRPointScanningHandler: QRPointScanningHandling {

    var delegate: QRPointScanningHandlerDelegate? {
        didSet {
            didSetDelegate = delegate != nil
        }
    }

    var didSetDelegate: Bool? = nil

    var viewReceivedInViewDidLoad: UIView? = nil
    var qrCodeValueReceived: String? = nil

    func handleViewDidLoad(_ view: UIView) {
        viewReceivedInViewDidLoad = view
    }

    func qrCodeValueScanned(_ value: String) {
        qrCodeValueReceived = value
    }

}

private final class TestableQRScannerScreenView: QRScannerScreenView {

    var didCallHideBlurOverlay: Bool? = nil

    override func hideBlurOverlay() {
        didCallHideBlurOverlay = true
    }
}

final class QRScannerViewControllerTests: XCTestCase {

    private var captureSessionHandler: TestableCaptureSessionHandler!
    private var qrPointScanningHandler: TestableQRPointScanningHandler!

    private var viewController: QRScannerViewController!

    override func setUp() {
        captureSessionHandler = TestableCaptureSessionHandler()
        qrPointScanningHandler = TestableQRPointScanningHandler()

        viewController = QRScannerViewController(
            captureSessionHandler: captureSessionHandler,
            qrPointScanningHandler: qrPointScanningHandler
        )
    }

    func testCaptureSessionHandlingDelegateIsSetOnInit() {
        XCTAssertTrue(captureSessionHandler.didSetDelegate!)
    }

    func testQRPointScanningHandlingDelegateIsSetOnInit() {
        XCTAssertTrue(qrPointScanningHandler.didSetDelegate!)
    }

    func testViewDidLoadCallsScreenViewHideBlurOverlay() {
        let testableScreenView = TestableQRScannerScreenView()
        viewController.view = testableScreenView

        viewController.viewDidLoad()

        XCTAssertTrue(testableScreenView.didCallHideBlurOverlay!)
    }

    func testViewDidLoadCallsCaptureSessionHandlingWithExpectedView() {
        XCTAssertNil(captureSessionHandler.viewReceivedInViewDidLoad)
        viewController.loadView()
        let expectedView = viewController.view

        viewController.viewDidLoad()

        XCTAssertEqual(expectedView, captureSessionHandler.viewReceivedInViewDidLoad)
    }

    func testViewDidLoadCallsQRPointScanningHandlingWithExpectedView() {
        XCTAssertNil(qrPointScanningHandler.viewReceivedInViewDidLoad)
        viewController.loadView()
        let expectedView = viewController.view

        viewController.viewDidLoad()

        XCTAssertEqual(expectedView, qrPointScanningHandler.viewReceivedInViewDidLoad)
    }

    func testViewWillAppearCallsCaptureSessionHandlingWithExpectedView() {
        XCTAssertNil(captureSessionHandler.viewReceivedInViewWillAppear)
        viewController.loadView()
        let expectedView = viewController.view

        viewController.viewWillAppear(true)

        XCTAssertEqual(expectedView, captureSessionHandler.viewReceivedInViewWillAppear)
    }

    func testViewWillDisappearCallsCaptureSessionHandlingWithExpectedView() {
        XCTAssertNil(captureSessionHandler.viewReceivedInViewWillDisappear)
        viewController.loadView()
        let expectedView = viewController.view

        viewController.viewWillDisappear(true)

        XCTAssertEqual(expectedView, captureSessionHandler.viewReceivedInViewWillDisappear)
    }
}
