//
//  ReferenceImageProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 24/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import ARKit

protocol ReferenceImageProviding {

    var image: UIImage { get }
    var referenceImages: Set<ARReferenceImage> { get }
}
