//
//  SideTapView+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 05/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

extension SideTapView {

    convenience init(side: Side, text: String) {
        self.init(
            side: side,
            text: text,
            colorProvider: AppColorProvider.shared,
            layoutProvider: AppLayoutProvider.shared
        )
    }
}
