//
//  ARScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class ARScreenView: FrameBasedView {

    override var insets: UIEdgeInsets { .init(all: 50) }

    var arSceneView: UIView? {
        willSet { arSceneView?.removeFromSuperview() }
        didSet {
            if let arSceneView = arSceneView {
                addSubview(arSceneView)
            }

            setNeedsLayout()
        }
    }

    let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, Smart University developer!"
        label.textColor = .green
        return label
    }()

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {
        var frames: [(UIView, CGRect)] = []

        let contentWidth = bounds.width - insets.left - insets.right

        let labelFrame =  CGRect(
            x: insets.top,
            y: insets.left,
            width: contentWidth,
            height: testLabel.height(constrainedToWidth: contentWidth)
        )
        frames.append((testLabel, labelFrame))

        if let arSceneView = arSceneView {
            let sceneViewFrame = CGRect(
                origin: CGPoint(x: 0, y: -safeAreaInsets.top),
                size: .init(width: bounds.width, height: bounds.height + safeAreaInsets.top + safeAreaInsets.bottom)
            )

            frames.append((arSceneView, sceneViewFrame))
        }

        return frames
    }
}

extension ARScreenView: BaseScreenView {

    func setupSubviews() {
        backgroundColor = .black

        addSubview(testLabel)
    }
}

extension ARScreenView: ARSceneContainerView { }
