//
//  QRScannerViewControllerExtTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 21/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest
import AVFoundation

extension QRScannerViewControllerTests {

    // MARK: - CaptureSessionHandlerDelegate implementation tests

    func testDidLoadPreviewLayerSetsScreenViewScannerPreviewLayer() {
        viewController.loadView()
        let controllerScreenView = viewController.view as! QRScannerScreenView
        XCTAssertNil(controllerScreenView.scannerPreviewLayer)
        let expectedPreviewLayer = AVCaptureVideoPreviewLayer()

        viewController.captureSessionHandler(captureSessionHandler, didLoadPreviewLayer: expectedPreviewLayer)

        XCTAssertEqual(expectedPreviewLayer, controllerScreenView.scannerPreviewLayer)
    }

    private var expectedScannedStringValue: String { "Test data 123" }
    private var expectedScannedObjectBounds: CGRect {
        .init(origin: .init(x: 8, y: 74), size: .init(width: 53, height: 99))
    }

    func testDidReceiveValidOutputSetsScannedValueCodeObjectBounds() {
        XCTAssertNil(viewController.scannedValueCodeObjectBounds)

        viewController.captureSessionHandler(
            captureSessionHandler,
            didReceiveValidOutput: expectedScannedStringValue,
            fromObjectWithBounds: expectedScannedObjectBounds
        )

        XCTAssertEqual(expectedScannedStringValue, viewController.scannedValueCodeObjectBounds?.scannedValue)
        XCTAssertEqual(expectedScannedObjectBounds, viewController.scannedValueCodeObjectBounds?.objectBounds)
    }

    func testDidReceiveValidOutputCallsQRPointScanningHandlingWithValueScanned() {
        XCTAssertNil(qrPointScanningHandler.qrCodeValueReceived)

        viewController.captureSessionHandler(
            captureSessionHandler,
            didReceiveValidOutput: expectedScannedStringValue,
            fromObjectWithBounds: expectedScannedObjectBounds
        )

        XCTAssertEqual(expectedScannedStringValue, qrPointScanningHandler.qrCodeValueReceived)
    }

    func testDidReceiveValidOutputCallsScreenViewShowBlurOverlayWithBoundsScanned() {
        let testableScreenView = TestableQRScannerScreenView()
        viewController.view = testableScreenView
        XCTAssertNil(testableScreenView.boundsReceivedInShowBlurOverlay)

        viewController.captureSessionHandler(
            captureSessionHandler,
            didReceiveValidOutput: expectedScannedStringValue,
            fromObjectWithBounds: expectedScannedObjectBounds
        )

        XCTAssertEqual(expectedScannedObjectBounds, testableScreenView.boundsReceivedInShowBlurOverlay)
    }

    private enum SessionErrorAlertExpectations {

        static let title = "Device not supported"
        static let message = "Your device does not support code scanning with a camera."
        static let preferredStyle = UIAlertController.Style.alert

        static let actionCount = 1
        static let actionTitle = "OK"
        static let actionStyle = UIAlertAction.Style.default
    }

    func testDidTriggerErrorWithVideoInputUnavailablePresentsAlertViewController() {

        viewController.captureSessionHandler(captureSessionHandler, didTriggerError: .videoInputUnavailable)

        let alertController = presentationHandler.viewControllerReceivedInPresent as! UIAlertController
        XCTAssertEqual(SessionErrorAlertExpectations.title, alertController.title)
        XCTAssertEqual(SessionErrorAlertExpectations.message, alertController.message)
        XCTAssertEqual(SessionErrorAlertExpectations.preferredStyle, alertController.preferredStyle)

        XCTAssertEqual(SessionErrorAlertExpectations.actionCount, alertController.actions.count)
        let alertAction = alertController.actions[0]
        XCTAssertEqual(SessionErrorAlertExpectations.actionTitle, alertAction.title)
        XCTAssertEqual(SessionErrorAlertExpectations.actionStyle, alertAction.style)
    }

    func testDidTriggerErrorWithMetadataOutputUnavailablePresentsAlertViewController() {

        viewController.captureSessionHandler(captureSessionHandler, didTriggerError: .metadataOutputUnavailable)

        let alertController = presentationHandler.viewControllerReceivedInPresent as! UIAlertController
        XCTAssertEqual(SessionErrorAlertExpectations.title, alertController.title)
        XCTAssertEqual(SessionErrorAlertExpectations.message, alertController.message)
        XCTAssertEqual(SessionErrorAlertExpectations.preferredStyle, alertController.preferredStyle)

        XCTAssertEqual(SessionErrorAlertExpectations.actionCount, alertController.actions.count)
        let alertAction = alertController.actions[0]
        XCTAssertEqual(SessionErrorAlertExpectations.actionTitle, alertAction.title)
        XCTAssertEqual(SessionErrorAlertExpectations.actionStyle, alertAction.style)
    }
}
