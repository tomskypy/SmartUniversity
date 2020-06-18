//
//  RoomsSceneObjectProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 25/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import SceneKit

struct RoomsSceneObjectProvider: SceneObjectProviding {

    let model: Model
    let meshObjectProvider: MeshObjectProviding

    init(model: Model, meshObjectProvider: MeshObjectProviding = MeshObjectProvider.shared) {
        self.model = model
        self.meshObjectProvider = meshObjectProvider
    }

    func makeNodeFor(_ objectType: SceneObjectType) -> SCNNode {
        switch objectType {
        case .poster(let physicalSize): return makePosterNode(posterSize: physicalSize, posterImage: model.posterImage)
        case .room(let objectData):     return makeRoomNode(objectData: objectData)
        }
    }

    private func makePosterNode(posterSize: CGSize, posterImage: UIImage) -> SCNNode {
        let imageMaterial = SCNMaterial()
        imageMaterial.diffuse.contents = posterImage

        let plane = SCNPlane(size: posterSize)
        plane.materials = [imageMaterial]

        let planeNode = SCNNode(geometry: plane)
        // Translate plane's node to face vertically
        planeNode.eulerAngles.x = -.pi / 2

        return planeNode
    }

    private func makeRoomNode(objectData: ARLocalizedObjectData) -> SCNNode {
        makeRoomNode(
            dimensions: objectData.dimensions,
            position: objectData.position,
            tint: UIColor(hex: objectData.tint)
        )
    }

    private func makeRoomNode(dimensions: ARDimensions, position: ARPosition, tint: UIColor?) -> SCNNode {
        let cubeMesh = meshObjectProvider.makeMeshBox(
            fromBox: makeBox(dimensions: dimensions, chamferRadius: 0, color: tint ?? model.defaultTint)
        )
        let cubeNode = SCNNode(geometry: cubeMesh)
        cubeNode.position = SCNVector3(position: position)

        return cubeNode
    }

    private func makeBox(dimensions: ARDimensions, chamferRadius: CGFloat, color: UIColor) -> SCNBox {

        let box = SCNBox(dimensions: dimensions, chamferRadius: chamferRadius)

        box.firstMaterial?.diffuse.contents = color
        box.firstMaterial?.transparency = CIColor(color: color).alpha

        return box
    }

    struct Model {
        let posterImage: UIImage
        let defaultTint: UIColor
    }
}
