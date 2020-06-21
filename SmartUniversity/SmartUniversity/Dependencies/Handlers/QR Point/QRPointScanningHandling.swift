//
//  QRPointScanningHandling.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 21/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol QRPointScanningHandling {

    var delegate: QRPointScanningHandlerDelegate? { get set }

    func handleViewDidLoad(_ view: UIView)
    func qrCodeValueScanned(_ value: String)
}
