//
//  PosterReferenceImageProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 24/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import ARKit

struct PosterReferenceImageProvider: ReferenceImageProviding {

    static let shared = PosterReferenceImageProvider()

    var referenceImages: Set<ARReferenceImage>

    private init() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Could not load QRPoint poster AR reference image resources.")
        }
        self.referenceImages = referenceImages
    }
}
