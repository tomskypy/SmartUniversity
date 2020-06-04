//
//  InfoOverlayView+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

extension InfoOverlayView {

    convenience init() {
        self.init(colorProvider: AppColorProvider.shared, layoutProvider: AppLayoutProvider.shared)
    }
}
