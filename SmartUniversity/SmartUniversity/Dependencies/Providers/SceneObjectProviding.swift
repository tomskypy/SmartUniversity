//
//  SceneObjectProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 24/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import ARKit

enum SceneObjectType {
    case poster(physicalSize: CGSize)
}

protocol SceneObjectProviding {

    init(posterImage: UIImage)

    func makeNodeFor(_ objectType: SceneObjectType) -> SCNNode
}
