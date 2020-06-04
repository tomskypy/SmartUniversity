//
//  QRScannerViewControllerQRPointScanningTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 22/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

@testable import SmartUniversity

extension QRScannerViewControllerTests {

    // MARK: - QRPointScanningHandlerDelegate implementation tests

    func testDidFetchQRPointCallsScreenViewShowBlurOverlayWithSavedBounds() {
        let testableScreenView = TestableQRScannerScreenView()
        scannerViewController.view = testableScreenView
        XCTAssertNil(testableScreenView.boundsReceivedInShowBlurOverlay)

        let expectedScannedObjectBounds = CGRect(origin: .init(x: 8, y: 74), size: .init(width: 53, height: 99))
        scannerViewController.scannedValueCodeObjectBounds = ("", expectedScannedObjectBounds)

        scannerViewController.qrPointScanningHandler(
            qrPointScanningHandler,
            didFetchQRPoint: QRPoint(uuidString: "", label: "", muniMapPlaceID: "", rooms: []),
            forScannedValue: ""
        )

        XCTAssertEqual(expectedScannedObjectBounds, testableScreenView.boundsReceivedInShowBlurOverlay)
    }

    func testCouldNotFetchQRPointCallsScreenViewHideBlurOverlay() {
        let testableScreenView = TestableQRScannerScreenView()
        scannerViewController.view = testableScreenView
        XCTAssertNil(testableScreenView.didCallHideBlurOverlay)

        scannerViewController.qrPointScanningHandler(qrPointScanningHandler, couldNotFetchQRPointForScannedValue: "")

        XCTAssertTrue(testableScreenView.didCallHideBlurOverlay!)
    }
}
