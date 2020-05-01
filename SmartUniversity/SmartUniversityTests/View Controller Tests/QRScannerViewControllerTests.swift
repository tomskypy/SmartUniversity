//
//  QRScannerViewControllerTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 21/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

final class TestableCaptureSessionHandler: CaptureSessionHandling {

    var didSetDelegate: Bool?

    var viewReceivedInViewDidLoad: UIView?
    var viewReceivedInViewWillAppear: UIView?
    var viewReceivedInViewWillDisappear: UIView?

    var delegate: CaptureSessionHandlerDelegate? {
        didSet { didSetDelegate = delegate != nil }
    }

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

final class TestableQRPointScanningHandler: QRPointScanningHandling {

    var didSetDelegate: Bool?

    var viewReceivedInViewDidLoad: UIView?
    var qrCodeValueReceived: String?

    var delegate: QRPointScanningHandlerDelegate? {
        didSet { didSetDelegate = delegate != nil }
    }

    func handleViewDidLoad(_ view: UIView) {
        viewReceivedInViewDidLoad = view
    }

    func qrCodeValueScanned(_ value: String) {
        qrCodeValueReceived = value
    }

}

final class TestableQRScannerScreenView: QRScannerScreenView {

    var didCallHideBlurOverlay: Bool?
    var boundsReceivedInShowBlurOverlay: CGRect?

    override func hideBlurOverlay() {
        didCallHideBlurOverlay = true
    }

    override func showBlurOverlay(maskBounds: CGRect) {
        boundsReceivedInShowBlurOverlay = maskBounds
    }
}

final class TestablePresentationHandler: PresentationHandling {

    var viewControllerReceivedInPresent: UIViewController?

    func present(_ viewController: UIViewController, onViewController: UIViewController, animated: Bool) {
        viewControllerReceivedInPresent = viewController
    }

}

final class QRScannerViewControllerTests: XCTestCase {

    var captureSessionHandler: TestableCaptureSessionHandler!
    var qrPointScanningHandler: TestableQRPointScanningHandler!
    var presentationHandler: TestablePresentationHandler!

    var viewController: QRScannerViewController!

    override func setUp() {
        captureSessionHandler = TestableCaptureSessionHandler()
        qrPointScanningHandler = TestableQRPointScanningHandler()
        presentationHandler = TestablePresentationHandler()

        viewController = QRScannerViewController(
            captureSessionHandler: captureSessionHandler,
            qrPointScanningHandler: qrPointScanningHandler,
            presentationHandler: presentationHandler
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
