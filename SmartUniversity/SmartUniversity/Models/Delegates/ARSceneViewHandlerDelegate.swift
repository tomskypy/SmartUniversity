//
//  ARSceneViewHandlerDelegate.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 24/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import ARKit

protocol ARSceneViewHandlerDelegate: AnyObject {

    func arSceneViewHandler(
        _ handler: ARSceneViewHandler,
        didDetectReferenceImage imageAnchor: ARImageAnchor,
        onNode node: SCNNode
    )

    func arSceneViewHandlerWillUpdate(_ handler: ARSceneViewHandler, sceneView: ARSCNView?)
}
