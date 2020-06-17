//
//  ARViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import ARKit

final class ARViewController: BaseViewController<ARScreenView> {

    private var sceneViewHandler: ARSceneViewHandling
    private let sceneObjectProvider: SceneObjectProviding

    private var roomsData: [ARLocalizedObjectData] = []

    init(
        sceneViewHandler: ARSceneViewHandling,
        sceneObjectProvider: SceneObjectProviding,
        roomsData: [ARLocalizedObjectData]
    ) {
        self.sceneViewHandler = sceneViewHandler
        self.sceneObjectProvider = sceneObjectProvider
        self.roomsData = roomsData
        super.init(nibName: nil, bundle: nil)

        self.sceneViewHandler.delegate = self
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneViewHandler.handleViewDidLoad(view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sceneViewHandler.handleViewWillAppear(view)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneViewHandler.handleViewWillDisappear(view)
    }
}

extension ARViewController: ARSceneViewHandlerDelegate {

    func arSceneViewHandler(
        _ handler: ARSceneViewHandler,
        didDetectReferenceImage imageAnchor: ARImageAnchor,
        onNode node: SCNNode
    ) {
        let posterNode = sceneObjectProvider.makeNodeFor(
            .poster(physicalSize: imageAnchor.referenceImage.physicalSize)
        )
        node.addChildNode(posterNode)

        roomsData.forEach { roomData in
            let roomNode = sceneObjectProvider.makeNodeFor(.room(objectData: roomData))
            node.addChildNode(roomNode)
        }
    }
}
