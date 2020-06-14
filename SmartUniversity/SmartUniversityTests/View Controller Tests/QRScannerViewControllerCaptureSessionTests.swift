//
//  QRScannerViewControllerCaptureExtTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 21/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest
import AVFoundation

@testable import SmartUniversity

extension QRScannerViewControllerTests {

    // MARK: - CaptureSessionHandlerDelegate implementation tests

    func testDidLoadPreviewLayerSetsScreenViewScannerPreviewLayer() {
        scannerViewController.loadView()
        let controllerScreenView = scannerViewController.view as! QRScannerScreenView
        XCTAssertNil(controllerScreenView.scannerPreviewLayer)
        let expectedPreviewLayer = AVCaptureVideoPreviewLayer()

        scannerViewController.captureSessionHandler(captureSessionHandler, didLoadPreviewLayer: expectedPreviewLayer)

        XCTAssertEqual(expectedPreviewLayer, controllerScreenView.scannerPreviewLayer)
    }

    private var expectedScannedStringValue: String { "Test data 123" }
    private var expectedScannedObjectBounds: CGRect {
        .init(origin: .init(x: 8, y: 74), size: .init(width: 53, height: 99))
    }

    func testDidReceiveValidOutputSetsScannedValueCodeObjectBounds() {
        XCTAssertNil(scannerViewController.scannedValueCodeObjectBounds)

        scannerViewController.captureSessionHandler(
            captureSessionHandler,
            didReceiveValidOutput: expectedScannedStringValue,
            fromObjectWithBounds: expectedScannedObjectBounds
        )

        XCTAssertEqual(expectedScannedStringValue, scannerViewController.scannedValueCodeObjectBounds?.scannedValue)
        XCTAssertEqual(expectedScannedObjectBounds, scannerViewController.scannedValueCodeObjectBounds?.objectBounds)
    }

    func testDidReceiveValidOutputCallsQRPointScanningHandlingWithValueScanned() {
        XCTAssertNil(qrPointScanningHandler.qrCodeValueReceived)

        scannerViewController.captureSessionHandler(
            captureSessionHandler,
            didReceiveValidOutput: expectedScannedStringValue,
            fromObjectWithBounds: expectedScannedObjectBounds
        )

        XCTAssertEqual(expectedScannedStringValue, qrPointScanningHandler.qrCodeValueReceived)
    }

    func testDidReceiveValidOutputCallsScreenViewShowBlurOverlayWithBoundsScanned() {
        let testableScreenView = TestableQRScannerScreenView()
        scannerViewController.view = testableScreenView
        XCTAssertNil(testableScreenView.boundsReceivedInShowBlurOverlay)

        scannerViewController.captureSessionHandler(
            captureSessionHandler,
            didReceiveValidOutput: expectedScannedStringValue,
            fromObjectWithBounds: expectedScannedObjectBounds
        )

        XCTAssertEqual(expectedScannedObjectBounds, testableScreenView.boundsReceivedInShowBlurOverlay)
    }

//    private enum SessionErrorAlertExpectations { // TODO replace with component
//
//        static let title = "Device not supported"
//        static let message = "Your device does not support code scanning with a camera."
//        static let preferredStyle = UIAlertController.Style.alert
//
//        static let actionCount = 1
//        static let actionTitle = "OK"
//        static let actionStyle = UIAlertAction.Style.default
//    }

//    func testDidTriggerErrorWithVideoInputUnavailablePresentsAlertViewController() {
//
//        scannerViewController.captureSessionHandler(captureSessionHandler, didTriggerError: .videoInputUnavailable)
//
//        let alertController = presentationHandler.viewControllerReceivedInPresent as! UIAlertController
//        XCTAssertEqual(SessionErrorAlertExpectations.title, alertController.title)
//        XCTAssertEqual(SessionErrorAlertExpectations.message, alertController.message)
//        XCTAssertEqual(SessionErrorAlertExpectations.preferredStyle, alertController.preferredStyle)
//
//        XCTAssertEqual(SessionErrorAlertExpectations.actionCount, alertController.actions.count)
//        let alertAction = alertController.actions[0]
//        XCTAssertEqual(SessionErrorAlertExpectations.actionTitle, alertAction.title)
//        XCTAssertEqual(SessionErrorAlertExpectations.actionStyle, alertAction.style)
//    }
//
//    func testDidTriggerErrorWithMetadataOutputUnavailablePresentsAlertViewController() {
//
//        scannerViewController.captureSessionHandler(captureSessionHandler, didTriggerError: .metadataOutputUnavailable)
//
//        let alertController = presentationHandler.viewControllerReceivedInPresent as! UIAlertController
//        XCTAssertEqual(SessionErrorAlertExpectations.title, alertController.title)
//        XCTAssertEqual(SessionErrorAlertExpectations.message, alertController.message)
//        XCTAssertEqual(SessionErrorAlertExpectations.preferredStyle, alertController.preferredStyle)
//
//        XCTAssertEqual(SessionErrorAlertExpectations.actionCount, alertController.actions.count)
//        let alertAction = alertController.actions[0]
//        XCTAssertEqual(SessionErrorAlertExpectations.actionTitle, alertAction.title)
//        XCTAssertEqual(SessionErrorAlertExpectations.actionStyle, alertAction.style)
//    }
}
