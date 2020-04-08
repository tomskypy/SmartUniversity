//
//  QRPointScanningHandler.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 08/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol QRPointScanningHandling {

    func setDelegate(_ delegate: QRPointScanningHandlerDelegate)

    func handleViewDidLoad(_ view: UIView)
    func qrCodeValueScanned(_ value: String)
}

final class QRPointScanningHandler: QRPointScanningHandling {

    func setDelegate(_ delegate: QRPointScanningHandlerDelegate) {
        fatalError("not implemented")
    }

    func handleViewDidLoad(_ view: UIView) {
        fatalError("not implemented")
    }

    func qrCodeValueScanned(_ value: String) {
        fatalError("not implemented")
    }
}
