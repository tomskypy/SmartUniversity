//
//  MeshObjectProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 27/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import SceneKit

final class MeshObjectProvider: MeshObjectProviding {

    static let shared = MeshObjectProvider()

    private static let meshingShaderModifier = {
        """
        float u = _surface.diffuseTexcoord.x;
        float v = _surface.diffuseTexcoord.y;
        int u100 = int(u * 100);
        int v100 = int(v * 100);
        if (u100 % 99 == 0 || v100 % 99 == 0) {
            // do nothing
        } else {
            discard_fragment();
        }
        """
    }()

    private init() { }

    func makeMeshBox(fromBox box: SCNBox) -> SCNBox {
        box.firstMaterial?.shaderModifiers = [SCNShaderModifierEntryPoint.surface: Self.meshingShaderModifier]
        box.firstMaterial?.isDoubleSided = true

        return box
    }
}
