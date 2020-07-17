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

    private static let maxRoomLabelWidth: CGFloat = 250

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

    func makeAndAddRoomLabel(text: String) -> UIView {
        let label = RoomLabelView(text: text)
        label.frame.size = label.size(constrainedToWidth: Self.maxRoomLabelWidth)
        addSubview(label)
        
        return label
    }
}

private class RoomLabelView: VerticalFrameBasedView {

    override var insets: UIEdgeInsets {
        .init(all: 4)
    }

    private let label = UILabel(font: .systemFont(ofSize: 25, weight: .light), textColor: .white)

    init(text: String) {
        super.init(frame: .zero)

        backgroundColor = UIColor.black.withAlphaComponent(0.45)
        layer.cornerRadius = 3

        label.text = text

        addSubview(label)
    }

    required init?(coder: NSCoder) { nil }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let leftMostFrameTuple = frames(forWidth: size.width).max(by: { $0.frame.maxY < $1.frame.maxY }) else {
            return .zero
        }

        return CGSize(width: leftMostFrameTuple.frame.maxX + insets.right, height: super.sizeThatFits(size).height)
    }

    override func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {

        let labelSize = label.size(constrainedToWidth: width - insets.horizontalSum)

        return [(label, CGRect(x: insets.left, y: insets.top, size: labelSize))]
    }
}

extension ARScreenView: ARSceneContainerView { }
