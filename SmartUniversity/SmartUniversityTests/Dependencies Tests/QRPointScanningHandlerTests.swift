//
//  QRPointScanningHandlerTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 22/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

private class TestableQRPointsProvider: QRPointsProviding {

    var providedPoints: [QRPoint]?
    var providedError: QRPointsProvidingError?

    func getAllQRPoints(completion: @escaping ([QRPoint]?, QRPointsProvidingError?) -> Void) {
        completion(providedPoints, providedError)
    }

    func fetchJSONData<JSONData>(
        withDataInfo info: RemoteJSONDataInfo,
        completion: @escaping (JSONData?, DataFetchError?) -> Void
    ) where JSONData : Decodable {
        fatalError("not implemented")
    }

}

private class TestableQRPointScanningHandlerDelegate: QRPointScanningHandlerDelegate {

    var qrPointReceivedInDidFetchQRPoint: QRPoint? = nil
    var scannedValueReceivedInDidFetchQRPoint: String? = nil

    var scannedValueReceivedInCouldNotFetchQRPoint: String? = nil

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

    var handler: QRPointScanningHandler!

    override func setUp() {
        qrPointsProvider = TestableQRPointsProvider()

        handler = QRPointScanningHandler(qrPointsProvider: qrPointsProvider)
    }

    func testViewDidLoadFetchesQrPointsFromProvider() {
        XCTAssertTrue(handler.qrPoints.isEmpty)

        let expectedQRPoints = [
            QRPoint(uuidString: "123abc", label: "", muniMapPlaceID: "", rooms: []),
            QRPoint(uuidString: "345abc", label: "", muniMapPlaceID: "", rooms: []),
            QRPoint(uuidString: "678abc", label: "", muniMapPlaceID: "", rooms: [])
        ]
        qrPointsProvider.providedPoints = expectedQRPoints

        handler.handleViewDidLoad(UIView())

        XCTAssertEqual(expectedQRPoints, handler.qrPoints)
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

        handler.qrPoints = qrPoints
        handler.delegate = delegate
        handler.qrCodeValueScanned(expectedScannedValue)

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

        handler.qrPoints = qrPoints
        handler.delegate = delegate
        handler.qrCodeValueScanned(expectedScannedValue)

        XCTAssertEqual(expectedScannedValue, delegate.scannedValueReceivedInCouldNotFetchQRPoint)
    }
}

private extension QRPointRemoteArray {

    init?(points: [QRPoint]?) {
        guard let points = points else { return nil }

        self.points = points
    }
}
