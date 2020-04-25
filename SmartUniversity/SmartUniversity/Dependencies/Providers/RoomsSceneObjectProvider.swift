//
//  RoomsSceneObjectProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 25/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import ARKit

struct RoomsSceneObjectProvider: SceneObjectProviding {

    let posterImage: UIImage

    init(posterImage: UIImage) {
        self.posterImage = posterImage
    }

    func makeNodeFor(_ objectType: SceneObjectType) -> SCNNode {
        switch objectType {
        case .poster(let physicalSize): return makePosterNode(posterSize: physicalSize, posterImage: posterImage)
        }
    }

    private func makePosterNode(posterSize: CGSize, posterImage: UIImage) -> SCNNode {
        let imageMaterial = SCNMaterial()
        imageMaterial.diffuse.contents = posterImage

        let plane = SCNPlane(
            width: posterSize.width,
            height: posterSize.height
        )
        plane.materials = [imageMaterial]

        let planeNode = SCNNode(geometry: plane)
        // Translate plane's node to face vertically
        planeNode.eulerAngles.x = -.pi / 2

        return planeNode
    }
}
