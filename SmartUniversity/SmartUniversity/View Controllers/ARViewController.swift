//
//  ARViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import ARKit

final class ARViewController: BaseViewController<ARScreenView> {

    private static let tipPresentationDelay = 2.0

    private var hasCapturedPoster: Bool = false
    private var tipShowingWorkItem: DispatchWorkItem?

    private var roomLabelViews: [SCNNode: UIView] = [:]

    private var sceneViewHandler: ARSceneViewHandling

    private let sceneObjectProvider: SceneObjectProviding
    private let roomsData: [ARLocalizedObjectData]

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        schedulePosterCaptureTipPresentation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        hidePosterCapturingTip()

        sceneViewHandler.handleViewWillDisappear(view)
    }

    private func schedulePosterCaptureTipPresentation() {
        let tipShowingWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }

            self.screenView?.revealTextOverlay(
                with: self.hasCapturedPoster ? .needToRecapturePoster: .aimAtPosterToInitiate
            )
        }
        self.tipShowingWorkItem = tipShowingWorkItem

        DispatchQueue.main.asyncAfter(deadline: .now() + Self.tipPresentationDelay, execute: tipShowingWorkItem)
    }

    private func hidePosterCapturingTip() {
        tipShowingWorkItem?.cancel()

        screenView?.hideTextOverlay()
    }
}

extension ARViewController: ARSceneViewHandlerDelegate {

    func arSceneViewHandler(
        _ handler: ARSceneViewHandler,
        didDetectReferenceImage imageAnchor: ARImageAnchor,
        onNode node: SCNNode
    ) {
        hasCapturedPoster = true

        let posterNode = sceneObjectProvider.makeNodeFor(
            .poster(physicalSize: imageAnchor.referenceImage.physicalSize)
        )
        node.addChildNode(posterNode)

        DispatchQueue.main.async {
            self.hidePosterCapturingTip()

            self.resetRoomLabelViews()

            self.roomsData.forEach { roomData in
                let roomNode = self.sceneObjectProvider.makeNodeFor(.room(objectData: roomData))
                roomNode.eulerAngles = SCNVector3Make(Float(Double.pi / 2), 0, 0)
                node.addChildNode(roomNode)

                guard let label = self.screenView?.makeAndAddRoomLabel(text: roomData.label) else { return }

                label.isHidden = true
                self.roomLabelViews[roomNode] = label
            }
        }
    }

    func arSceneViewHandlerWillUpdate(_ handler: ARSceneViewHandler, sceneView: ARSCNView?) {
        guard let sceneView = sceneView else { return }

        DispatchQueue.main.async {
            for (roomNode, roomLabelView) in self.roomLabelViews {
                let labelScreenCoordinate = sceneView.projectPoint(roomNode.worldPosition)
                guard labelScreenCoordinate.z < 1 else {
                    roomLabelView.isHidden = true
                    return
                }

                roomLabelView.center = CGPoint(x: CGFloat(labelScreenCoordinate.x), y: CGFloat(labelScreenCoordinate.y))

                if let rotation = sceneView.session.currentFrame?.camera.eulerAngles.z {
                    roomLabelView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation + Float.pi / 2))
                }

                if roomLabelView.isHidden {
                    roomLabelView.isHidden = false
                }
            }
        }
    }

    private func resetRoomLabelViews() {

        roomLabelViews.values.forEach { $0.removeFromSuperview() }
        roomLabelViews = [:]
    }
}
