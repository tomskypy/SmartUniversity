//
//  CRRect+Inits.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import CoreGraphics

extension CGRect {

    init(x: CGFloat, y: CGFloat, size: CGSize) {
        self.init(origin: .init(x: x, y: y), size: size)
    }
}
