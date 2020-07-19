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

    func testCouldNotFetchQRPointCallsScreenViewHideBlurOverlay() {
        let testableScreenView = TestableQRScannerScreenView()
        scannerViewController.view = testableScreenView
        XCTAssertNil(testableScreenView.didCallHideBlurOverlay)

        scannerViewController.qrPointScanningHandler(
            qrPointScanningHandler,
            couldNotFetchQRPointDataForScannedValue: ""
        )

        XCTAssertTrue(testableScreenView.didCallHideBlurOverlay!)
    }
}
