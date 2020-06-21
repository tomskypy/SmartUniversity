//
//  ARViewController+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

extension ARViewController {

    convenience init(roomsData: [ARLocalizedObjectData]) {
        let arReferenceImages = PosterReferenceImageProvider.shared.referenceImages
        let posterImage = PosterReferenceImageProvider.shared.image
        
        self.init(
            sceneViewHandler: ARSceneViewHandler(referenceImages: arReferenceImages),
            sceneObjectProvider: RoomsSceneObjectProvider(
                model: .init(posterImage: posterImage, defaultTint: UIColor.systemPink) // FIXME: make a dependency for tint
            ),
            roomsData: roomsData
        )
    }
}
