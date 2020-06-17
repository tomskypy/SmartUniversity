//
//  ARViewController+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

extension ARViewController {

    convenience init() {
        let arReferenceImages = PosterReferenceImageProvider.shared.referenceImages
        let posterImage = PosterReferenceImageProvider.shared.image
        self.init(
            sceneViewHandler: ARSceneViewHandler(referenceImages: arReferenceImages),
            sceneObjectProvider: RoomsSceneObjectProvider(
                model: .init(posterImage: posterImage, defaultTint: UIColor.systemPink) // FIXME: make a dependency for tint
            ),
            roomsData: [ // FIXME: Replace with actual data/provider
                ARLocalizedObjectData(
                    label: "test1",
                    dimensions: .init(width: 2, height: 2, length: 2),
                    position: .init(right: 0, up: 0, front: 10),
                    tint: "#"
                ),
                ARLocalizedObjectData(
                    label: "test2",
                    dimensions: .init(width: 1, height: 1, length: 1),
                    position: .init(right: 0, up: 3, front: 10),
                    tint: "#008080FF"
                )
            ]
        )
    }
}
