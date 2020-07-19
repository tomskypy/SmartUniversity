//
//  MunimapScaleProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 19/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import CoreGraphics

struct MunimapScaleProvider: MunimapScaleProviding {

    let screenScale: CGFloat

    init(screenScale: CGFloat) {
        self.screenScale = screenScale
    }

    func mapZoomScale(forViewFrame viewFrame: CGRect, mapSize: CGSize) -> CGFloat {
        let xRatio = viewFrame.width * screenScale / mapSize.width
        let yRatio = viewFrame.height * screenScale / mapSize.height

        let scale = max(xRatio, yRatio) / 2

        return max(scale, 1)
    }
}
