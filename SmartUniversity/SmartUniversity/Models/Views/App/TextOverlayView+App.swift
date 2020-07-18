//
//  TextOverlayView+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

extension TextOverlayView {

    convenience init() {
        self.init(colorProvider: AppColorProvider.shared, layoutProvider: AppLayoutProvider.shared)
    }
}
