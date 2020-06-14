//
//  CornerTapView+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 14/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

extension CornerTapView {

    convenience init(configuration: Configuration) {
        self.init(
            configuration: configuration,
            colorProvider: AppColorProvider.shared,
            layoutProvider: AppLayoutProvider.shared
        )
    }
}
