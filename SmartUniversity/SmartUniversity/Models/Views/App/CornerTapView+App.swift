//
//  CornerTapView+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 14/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

extension CornerTapView {

    convenience init(content: Content) {
        self.init(content: content, colorProvider: AppColorProvider.shared, layoutProvider: AppLayoutProvider.shared)
    }
}
