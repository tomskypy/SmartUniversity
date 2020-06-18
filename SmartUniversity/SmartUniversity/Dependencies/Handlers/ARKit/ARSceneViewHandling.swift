//
//  ARSceneViewHandling.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import ARKit

protocol ARSceneViewHandling {

    var delegate: ARSceneViewHandlerDelegate? { get set }

    var referenceImages: Set<ARReferenceImage> { get set }

    func handleViewDidLoad(_ view: UIView)
    func handleViewWillAppear(_ view: UIView)
    func handleViewWillDisappear(_ view: UIView)
}
