//
//  QRPointScanningHandler.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 08/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class QRPointScanningHandler: QRPointScanningHandling {

    weak var delegate: QRPointScanningHandlerDelegate?

    var qrPoints: [QRPoint] = []

    private let qrPointsProvider: QRPointsProviding
    private let qrPointIDParser: QRPointIDParsing

    init(
        qrPointsProvider: QRPointsProviding = RemoteDataProvider.shared,
        qrPointIDParser: QRPointIDParsing = QRPointIDParser()
    ) {
        self.qrPointsProvider = qrPointsProvider
        self.qrPointIDParser = qrPointIDParser
    }

    func handleViewDidLoad(_ view: UIView) {
        prefetchAllQRPoints()
    }

    func qrCodeValueScanned(_ value: String) {
        guard let qrPointUUID = qrPointIDParser.parseUUID(from: value) else {
            delegate?.qrPointScanningHandler(self, couldNotParseQRPointIDForScannedValue: value)
            return
        }

        if let detectedQRPoint = qrPoints.first(where: { UUID(uuidString: $0.uuidString) == qrPointUUID }) {
            delegate?.qrPointScanningHandler(self, didFetchQRPoint: detectedQRPoint, forScannedValue: value)
        } else {
            delegate?.qrPointScanningHandler(self, couldNotFetchQRPointDataForScannedValue: value)
        }
    }

    private func prefetchAllQRPoints() {
        qrPointsProvider.getAllQRPoints { points, _ in // FIXME: Implement the error handling
            self.qrPoints = points ?? []
        }
    }
}
