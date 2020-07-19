//
//  QRPointScanningHandler.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 08/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class QRPointScanningHandler: QRPointScanningHandling {

    private static let fetchRetryPeriod = 3.0

    weak var delegate: QRPointScanningHandlerDelegate?

    var qrPoints: [QRPoint] = []

    var hasLoadedQRPoints: Bool = false

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

        if hasLoadedQRPoints == false {
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.notifyDelegateWithQRPoint(for: qrPointUUID, scannedValue: value)
            }
            return
        }

        notifyDelegateWithQRPoint(for: qrPointUUID, scannedValue: value)
    }

    private func notifyDelegateWithQRPoint(for uuid: UUID, scannedValue: String) {
        guard let qrPoint = qrPoint(for: uuid) else {
            delegate?.qrPointScanningHandler(self, couldNotFetchQRPointDataForScannedValue: scannedValue)
            return
        }

        delegate?.qrPointScanningHandler(self, didFetchQRPoint: qrPoint, forScannedValue: scannedValue)
    }

    private func qrPoint(for uuid: UUID) -> QRPoint? {
        qrPoints.first(where: { UUID(uuidString: $0.uuidString) == uuid })
    }

    private func prefetchAllQRPoints() {
        qrPointsProvider.getAllQRPoints {[weak self] points, error in
            if error != nil {
                return DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + Self.fetchRetryPeriod) {
                    self?.prefetchAllQRPoints()
                }
            }

            self?.hasLoadedQRPoints = true
            self?.qrPoints = points ?? []
        }
    }
}
