//
//  QRPointScanningHandler.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 08/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol QRPointScanningHandling {

    var delegate: QRPointScanningHandlerDelegate? { get set }

    func handleViewDidLoad(_ view: UIView)
    func qrCodeValueScanned(_ value: String)
}

final class QRPointScanningHandler: QRPointScanningHandling {

    weak var delegate: QRPointScanningHandlerDelegate?

    var qrPoints: [QRPoint] = []

    private let qrPointsProvider: QRPointsProviding

    init(qrPointsProvider: QRPointsProviding = RemoteDataProvider.shared) {
        self.qrPointsProvider = qrPointsProvider
    }

    func handleViewDidLoad(_ view: UIView) {
        prefetchAllQRPoints()
    }

    func qrCodeValueScanned(_ value: String) {

        if let detectedQRPoint = qrPoints.first(where: { $0.uuidString == value}) {
            delegate?.qrPointScanningHandler(self, didFetchQRPoint: detectedQRPoint, forScannedValue: value)
        } else {
            delegate?.qrPointScanningHandler(self, couldNotFetchQRPointForScannedValue: value)
        }
    }

    private func prefetchAllQRPoints() {
        qrPointsProvider.getAllQRPoints { points, _ in // FIXME: Implement the error handling
            self.qrPoints = points ?? []
        }
    }
}
