//
//  QRPointScanningHandlerTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 22/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

@testable import SmartUniversity

private class TestableQRPointsProvider: QRPointsProviding {

    var providedPoints: [QRPoint]?
    var providedError: QRPointsProvidingError?

    func getAllQRPoints(completion: @escaping ([QRPoint]?, QRPointsProvidingError?) -> Void) {
        completion(providedPoints, providedError)
    }

    func fetchJSONData<JSONData>(
        withDataInfo info: RemoteJSONDataInfo,
        completion: @escaping (JSONData?, DataFetchError?) -> Void,
        onQueue queue: DispatchQueue
    ) where JSONData : Decodable {
        fatalError("not implemented")
    }

}

private class TestableQRPointScanningHandlerDelegate: QRPointScanningHandlerDelegate {

    var qrPointReceivedInDidFetchQRPoint: QRPoint?
    var scannedValueReceivedInDidFetchQRPoint: String?

    var scannedValueReceivedInCouldNotFetchQRPoint: String?

    func qrPointScanningHandler(
        _ handler: QRPointScanningHandling,
        didFetchQRPoint qrPoint: QRPoint,
        forScannedValue value: String
    ) {
        qrPointReceivedInDidFetchQRPoint = qrPoint
        scannedValueReceivedInDidFetchQRPoint = value
    }

    func qrPointScanningHandler(_ handler: QRPointScanningHandling, couldNotFetchQRPointForScannedValue value: String) {
        scannedValueReceivedInCouldNotFetchQRPoint = value
    }
}

final class QRPointScanningHandlerTests: XCTestCase {

    private var qrPointsProvider: TestableQRPointsProvider!

    var scanningHandler: QRPointScanningHandler!

    override func setUp() {
        qrPointsProvider = .init()

        scanningHandler = .init(qrPointsProvider: qrPointsProvider)
    }

    func testViewDidLoadFetchesQrPointsFromProvider() {
        XCTAssertTrue(scanningHandler.qrPoints.isEmpty)

        let expectedQRPoints = [
            QRPoint(uuidString: "123abc", label: "", muniMapPlaceID: "", rooms: []),
            QRPoint(uuidString: "345abc", label: "", muniMapPlaceID: "", rooms: []),
            QRPoint(uuidString: "678abc", label: "", muniMapPlaceID: "", rooms: [])
        ]
        qrPointsProvider.providedPoints = expectedQRPoints

        scanningHandler.handleViewDidLoad(UIView())

        XCTAssertEqual(expectedQRPoints, scanningHandler.qrPoints)
    }

    func testQrCodeValueScannedCallsDelegateDidFetchQRPointIfValueMatchesSomeQRPoint() {
        let delegate = TestableQRPointScanningHandlerDelegate()
        XCTAssertNil(delegate.qrPointReceivedInDidFetchQRPoint)
        XCTAssertNil(delegate.scannedValueReceivedInDidFetchQRPoint)

        let qrPoints = [
            QRPoint(uuidString: "123abc", label: "", muniMapPlaceID: "", rooms: []),
            QRPoint(uuidString: "345abc", label: "", muniMapPlaceID: "", rooms: []),
            QRPoint(uuidString: "678abc", label: "", muniMapPlaceID: "", rooms: [])
        ]
        let expectedQRPoint = qrPoints[1]
        let expectedScannedValue = expectedQRPoint.uuidString

        scanningHandler.qrPoints = qrPoints
        scanningHandler.delegate = delegate
        scanningHandler.qrCodeValueScanned(expectedScannedValue)

        XCTAssertEqual(expectedQRPoint, delegate.qrPointReceivedInDidFetchQRPoint)
        XCTAssertEqual(expectedScannedValue, delegate.scannedValueReceivedInDidFetchQRPoint)
    }

    func testQrCodeValueScannedCallsDelegatecCouldNotFetchQRPointIfValueDoesNotMatch() {
        let delegate = TestableQRPointScanningHandlerDelegate()
        XCTAssertNil(delegate.scannedValueReceivedInCouldNotFetchQRPoint)

        let qrPoints = [
            QRPoint(uuidString: "123abc", label: "", muniMapPlaceID: "", rooms: [])
        ]
        let expectedScannedValue = "098zyx"

        scanningHandler.qrPoints = qrPoints
        scanningHandler.delegate = delegate
        scanningHandler.qrCodeValueScanned(expectedScannedValue)

        XCTAssertEqual(expectedScannedValue, delegate.scannedValueReceivedInCouldNotFetchQRPoint)
    }
}

private extension QRPointRemoteArray {

    init?(points: [QRPoint]?) {
        guard let points = points else { return nil }

        self.points = points
    }
}
