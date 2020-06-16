//
//  QRScannerScreenView+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 16/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

extension QRScannerScreenView {

    convenience init() {
        self.init(colorProvider: AppColorProvider.shared)
    }
}
