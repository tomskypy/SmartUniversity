//
//  ARScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

enum ARScreenTextOverlayContent {
    case aimAtPosterToInitiate
    case needToRecapturePoster
}

final class ARScreenView: TitledScreenView {

    private static let maxRoomLabelWidth: CGFloat = 250

    var insets: UIEdgeInsets { .init(all: 50) }

    var arSceneView: UIView? {
        willSet { arSceneView?.removeFromSuperview() }
        didSet {
            if let arSceneView = arSceneView {
                insertSubview(arSceneView, at: 0)
            }

            setNeedsLayout()
        }
    }

    private let textOverlayView = TextOverlayView()

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

        let fullscreenViewOrigin = CGPoint(x: 0, y: -safeAreaInsets.top)

        let sceneViewFrame = CGRect(
            origin: fullscreenViewOrigin,
            size: CGSize(width: bounds.width, height: contentHeight)
        )

        let textOverlayFrame = CGRect(
            origin: fullscreenViewOrigin,
            size: textOverlayView.size(constrainedToWidth: bounds.width)
        )

        return frames + [(arSceneView, sceneViewFrame), (textOverlayView, textOverlayFrame)]
    }

    override func setupSubviews() {
        backgroundColor = .black

        addSubviewAboveScreenTitle(textOverlayView)
    }

    func revealTextOverlay(with content: ARScreenTextOverlayContent) {
        textOverlayView.reveal(forPeriod: content.period, text: content.text)

        setNeedsLayout()
    }

    func hideTextOverlay() {
        textOverlayView.isHidden = true
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

private extension ARScreenTextOverlayContent {

    var text: String {
        switch self {
            case .aimAtPosterToInitiate:    return "Aim at the QR Poster to initiate the AR experience"
            case .needToRecapturePoster:    return "The QR Poster needs to be recaptured to continue"
        }
    }

    var period: TextOverlayView.VisibilityPeriod {
        switch self {
            case .aimAtPosterToInitiate:    return .infinite
            case .needToRecapturePoster:    return .long
        }
    }
}
