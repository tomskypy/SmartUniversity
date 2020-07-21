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
}
