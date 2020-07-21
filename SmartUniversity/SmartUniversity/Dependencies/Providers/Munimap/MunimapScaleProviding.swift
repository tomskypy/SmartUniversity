//
//  MunimapScaleProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 19/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import CoreGraphics

protocol MunimapScaleProviding {

    func mapZoomScale(forViewFrame viewFrame: CGRect, mapSize: CGSize) -> CGFloat
}
