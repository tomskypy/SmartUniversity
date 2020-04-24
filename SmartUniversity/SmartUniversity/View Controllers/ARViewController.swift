//
//  ARViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import ARKit

final class ARViewController: BaseViewController<ARScreenView> {

    private var arSceneViewHandler: ARSceneViewHandling

    convenience init() {
        let arReferenceImages = PosterReferenceImageProvider.shared.referenceImages
        self.init(arSceneViewHandler: ARSceneViewHandler(referenceImages: arReferenceImages))
    }

    init(arSceneViewHandler: ARSceneViewHandling) {
        self.arSceneViewHandler = arSceneViewHandler
        super.init(nibName: nil, bundle: nil)

        self.arSceneViewHandler.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        arSceneViewHandler.handleViewDidLoad(view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        arSceneViewHandler.handleViewWillAppear(view)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        arSceneViewHandler.handleViewWillDisappear(view)
    }
}

extension ARViewController: ARSceneViewHandlerDelegate {

    func arSceneViewHandler(_ handler: ARSceneViewHandler, didDetectReferenceImageOnAnchor anchor: ARAnchor) {
        // TODO implement AR poster drawing and world centering 
    }
}
