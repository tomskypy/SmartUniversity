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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
