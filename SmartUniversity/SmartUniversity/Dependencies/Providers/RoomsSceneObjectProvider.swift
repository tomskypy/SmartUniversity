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
        case .room(let objectData):     return makeRoomNode(objectData: objectData)
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

    private func makeRoomNode(objectData: ARLocalizedObject) -> SCNNode {
        makeRoomNode(dimensions: objectData.dimensions, position: objectData.position)
    }

    private func makeRoomNode(dimensions: ARDimensions, position: ARPosition) -> SCNNode {
        let cubeMesh = getMeshBox(dimensions: dimensions, chamferRadius: 0)
        let cubeNode = SCNNode(geometry: cubeMesh)
        cubeNode.position = SCNVector3(position.right ?? 0, position.up ?? 0, (position.front ?? 0) * -1) // TODO convenience init ?
//        cubeNode.runAction(self.objectHighlightAction)
        return cubeNode
    }

    private func getMeshBox(dimensions: ARDimensions, chamferRadius: CGFloat) -> SCNBox { // TODO merge with getBox

        let sm = "float u = _surface.diffuseTexcoord.x; \n" +
            "float v = _surface.diffuseTexcoord.y; \n" +
            "int u100 = int(u * 100); \n" +
            "int v100 = int(v * 100); \n" +
            "if (u100 % 99 == 0 || v100 % 99 == 0) { \n" +
            "  // do nothing \n" +
            "} else { \n" +
            "    discard_fragment(); \n" +
        "} \n"

        let box = getBox(dimensions: dimensions, chamferRadius: chamferRadius)

        box.firstMaterial?.emission.contents = UIColor.green // TODO what is this color
        box.firstMaterial?.shaderModifiers = [SCNShaderModifierEntryPoint.surface: sm]
        box.firstMaterial?.isDoubleSided = true

        return box
    }

    private func getBox(dimensions: ARDimensions, chamferRadius: CGFloat) -> SCNBox {

        let box = SCNBox( // TODO convenience init(dimensions:)
            width: dimensions.width,
            height: dimensions.height,
            length: dimensions.length,
            chamferRadius: chamferRadius
        )

        let hue: CGFloat = 0.6
        let color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        box.firstMaterial?.diffuse.contents = color  // TODO color settings out

        box.firstMaterial?.transparency = 0.8

        return box
    }
}