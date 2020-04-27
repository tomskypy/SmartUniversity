//
//  SCNObject+Init.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 27/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import SceneKit

extension SCNVector3 {

    init(position: ARPosition) {
        self.init(position.right, position.up, -position.front)
    }
}

extension SCNPlane {

    convenience init(size: CGSize) {
        self.init(width: size.width, height: size.height)
    }
}

extension SCNBox {

    convenience init(dimensions: ARDimensions, chamferRadius: CGFloat) {
        self.init(
            width: dimensions.width,
            height: dimensions.height,
            length: dimensions.length,
            chamferRadius: chamferRadius
        )
    }
}
