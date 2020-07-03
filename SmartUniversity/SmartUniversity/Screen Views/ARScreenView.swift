//
//  ARScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class ARScreenView: TitledScreenView {

    var insets: UIEdgeInsets { .init(all: 50) }

    var arSceneView: UIView? {
        willSet { arSceneView?.removeFromSuperview() }
        didSet {
            if let arSceneView = arSceneView {
                addSubview(arSceneView)
            }

            setNeedsLayout()
        }
    }

    override init(layoutProvider: LayoutProviding) {
        super.init(layoutProvider: layoutProvider)

        titleText = "AR View"
    }

    required init?(coder: NSCoder) { nil }

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {

        let frames = super.frames(forBounds: bounds)

        guard let arSceneView = arSceneView else {
            return frames
        }

        let contentHeight = bounds.height + safeAreaInsets.verticalSum

        let sceneViewFrame = CGRect(
            x: 0,
            y: -safeAreaInsets.top,
            size: CGSize(width: bounds.width, height: contentHeight)
        )

        return frames + [(arSceneView, sceneViewFrame)]
    }

    override func setupSubviews() {
        backgroundColor = .black
    }
}

extension ARScreenView: ARSceneContainerView { }
