//
//  ARMapPageScreenView+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

extension ARMapPageScreenView {

    convenience init() {
        self.init(colorProvider: AppColorProvider.shared)
    }
}
