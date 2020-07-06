//
//  QRScannerViewControllerTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 21/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

@testable import SmartUniversity
import AVFoundation

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

final class TestableExternalAppLauncher: ExternalAppLaunching {
    var didCallLaunchSettings: Bool?

    func launchSettings(completion: (() -> Void)?) { // TODO add tests
        didCallLaunchSettings = true
    }
}

final class TestableCaptureAuthorizationStatusProvider: CaptureAuthorizationStatusProviding {

    var videoCaptureAuthorizationStatus: AVAuthorizationStatus { // TODO add tests
        .authorized
    }
}

final class QRScannerViewControllerTests: XCTestCase {

    var captureSessionHandler: TestableCaptureSessionHandler!
    var qrPointScanningHandler: TestableQRPointScanningHandler!
    var presentationHandler: TestablePresentationHandler!
    var externalAppLauncher: TestableExternalAppLauncher!
    var authorizationStatusProvider: TestableCaptureAuthorizationStatusProvider!

    var scannerViewController: QRScannerViewController!

    override func setUp() {
        captureSessionHandler = .init()
        qrPointScanningHandler = .init()
        presentationHandler = .init()
        externalAppLauncher = .init()
        authorizationStatusProvider = .init()

        scannerViewController = .init(
            captureSessionHandler: captureSessionHandler,
            qrPointScanningHandler: qrPointScanningHandler,
            presentationHandler: presentationHandler,
            externalAppLauncher: externalAppLauncher,
            authorizationStatusProvider: authorizationStatusProvider
        )
    }

    func testCaptureSessionHandlingDelegateIsSetOnInit() {
        XCTAssertTrue(captureSessionHandler.didSetDelegate!)
    }

    func testQRPointScanningHandlingDelegateIsSetOnInit() {
        XCTAssertTrue(qrPointScanningHandler.didSetDelegate!)
    }

//    func testViewDidLoadCallsScreenViewHideBlurOverlay() { // TODO replace with more meaningful test
//        let testableScreenView = TestableQRScannerScreenView()
//        scannerViewController.view = testableScreenView
//
//        scannerViewController.viewDidLoad()
//
//        XCTAssertTrue(testableScreenView.didCallHideBlurOverlay!)
//    }

    func testViewDidLoadCallsCaptureSessionHandlingWithExpectedView() {
        XCTAssertNil(captureSessionHandler.viewReceivedInViewDidLoad)
        scannerViewController.loadView()
        let expectedView = scannerViewController.view

        scannerViewController.viewDidLoad()

        XCTAssertEqual(expectedView, captureSessionHandler.viewReceivedInViewDidLoad)
    }

    func testViewDidLoadCallsQRPointScanningHandlingWithExpectedView() {
        XCTAssertNil(qrPointScanningHandler.viewReceivedInViewDidLoad)
        scannerViewController.loadView()
        let expectedView = scannerViewController.view

        scannerViewController.viewDidLoad()

        XCTAssertEqual(expectedView, qrPointScanningHandler.viewReceivedInViewDidLoad)
    }

    func testViewWillAppearCallsCaptureSessionHandlingWithExpectedView() {
        XCTAssertNil(captureSessionHandler.viewReceivedInViewWillAppear)
        scannerViewController.loadView()
        let expectedView = scannerViewController.view

        scannerViewController.viewWillAppear(true)

        XCTAssertEqual(expectedView, captureSessionHandler.viewReceivedInViewWillAppear)
    }

    func testViewWillDisappearCallsCaptureSessionHandlingWithExpectedView() {
        XCTAssertNil(captureSessionHandler.viewReceivedInViewWillDisappear)
        scannerViewController.loadView()
        let expectedView = scannerViewController.view

        scannerViewController.viewWillDisappear(true)

        XCTAssertEqual(expectedView, captureSessionHandler.viewReceivedInViewWillDisappear)
    }
}
