//
//  ARLocalizedObject.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 29/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import CoreGraphics

struct ARLocalizedObject: Decodable {

    let label: String
    let dimensions: ARDimensions
    let position: ARPosition

    private enum CodingKeys: String, CodingKey {
        case label
        case dimensions = "dimen"
        case position = "pos"
    }
}

struct ARPosition: Decodable {

    let right: CGFloat?
    let up: CGFloat?
    let front: CGFloat?

    private enum CodingKeys: String, CodingKey {
        case right = "r"
        case up = "u"
        case front = "f"
    }

}

struct ARDimensions: Decodable {

    let width: CGFloat
    let height: CGFloat
    let length: CGFloat

    private enum CodingKeys: String, CodingKey {
        case width = "w"
        case height = "h"
        case length = "l"
    }
}
