//
//  QRScannerScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 07/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerScreenView: TitledScreenView {

    var scannerPreviewLayer: AVCaptureVideoPreviewLayer? {
        willSet { removePreviewSublayer(previewLayer: scannerPreviewLayer) }
        didSet { configurePreviewSublayer(with: scannerPreviewLayer) }
    }

    var munimapButton: UIButton {
        sideButtonsView.munimapButton
    }

    var roomsButton: UIButton {
        sideButtonsView.roomsButton
    }

    private var bottomOverlayButtonConfiguration: InteractiveOverlayView.ButtonConfiguration? {
        didSet { bottomOverlay.buttonConfiguration = bottomOverlayButtonConfiguration }
    }
    private var bottomOverlayState: InteractiveOverlayView.State? {
        didSet { configureBottomOverlay(for: bottomOverlayState) }
    }
    private var lastOverlayHideAnimationWorkItem: DispatchWorkItem?

    // MARK: - Views

    let blurredOverlayView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    private let sideButtonsView = SideButtonsView()
    private let bottomOverlay = InteractiveOverlayView()

    // MARK: - Dependencies

    private let colorProvider: ColorProviding

    // MARK: - Inits

    init(colorProvider: ColorProviding, layoutProvider: LayoutProviding) {
        self.colorProvider = colorProvider
        super.init(layoutProvider: layoutProvider)

        titleText = "QR Scanner"
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Layouting

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {
        let frames = super.frames(forBounds: bounds)

        let blurredOverlayFrame = CGRect(origin: .zero, size: bounds.size)

        let sideButtonsSize = sideButtonsView.size(constrainedToWidth: bounds.width)
        let sideButtonsFrame = CGRect(
            x: bounds.width - sideButtonsSize.width,
            y: (bounds.height - sideButtonsSize.height) / 2,
            size: sideButtonsSize
        )

        let bottomOverlayFrameSize = bottomOverlay.size(constrainedToWidth: bounds.width)
        let bottomOverlayFrame = CGRect(
            x: 0,
            y: bounds.height - bottomOverlayFrameSize.height,
            size: bottomOverlayFrameSize
        )

        return frames + [
            (blurredOverlayView, blurredOverlayFrame),
            (sideButtonsView, sideButtonsFrame),
            (bottomOverlay, bottomOverlayFrame)
        ]
    }

    override func setupSubviews() {
        addSubviews(blurredOverlayView, sideButtonsView)
    }

    // MARK: - Reset

    func reset() {
        hideBlurOverlay()
        hideBottomOverlay()
    }

    // MARK: - Blur square overlay

    func showBlurOverlay(maskBounds: CGRect) {
        resetBlurOverlayAnimations()

        blurredOverlayView.layer.mask = makeRectangularMask(innerBounds: maskBounds)

        if blurredOverlayView.isHidden {
            blurredOverlayView.isHidden = false
            blurredOverlayView.alpha = 1
        }
    }

    func hideBlurOverlay() {
        blurredOverlayView.isHidden = true
    }

    // MARK: - Bottom overlay

    func configureBottomOverlay(
        for state: InteractiveOverlayView.State,
        buttonConfiguration: InteractiveOverlayView.ButtonConfiguration? = nil
    ) {
        bottomOverlayState = state
        bottomOverlayButtonConfiguration = buttonConfiguration
    }

    func hideBottomOverlay() {
        bottomOverlayState = nil
    }

    // MARK: - Helpers - Reset

    private func resetBlurOverlayAnimations() {
        lastOverlayHideAnimationWorkItem?.cancel()

        let overlayHideAnimationWorkItem = DispatchWorkItem(block: {
            UIView.animate(
                withDuration: 1,
                delay: 0,
                options: .curveEaseIn,
                animations: { self.blurredOverlayView.alpha = 0 },
                completion: { _ in self.hideBlurOverlay() }
            )
        })
        lastOverlayHideAnimationWorkItem = overlayHideAnimationWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: overlayHideAnimationWorkItem)
    }

    // MARK: - Helpers - Configuration

    private func configureBottomOverlay(for state: InteractiveOverlayView.State?) {
        guard let state = bottomOverlayState else {
            return bottomOverlay.removeFromSuperview()
        }

        bottomOverlay.state = state
        addSubview(bottomOverlay)
    }

    private func configurePreviewSublayer(with scannerPreviewLayer: AVCaptureVideoPreviewLayer?) {
        guard let scannerPreviewLayer = scannerPreviewLayer else { return }

        layer.sublayers?.insert(scannerPreviewLayer, at: 0)
    }

    private func removePreviewSublayer(previewLayer: AVCaptureVideoPreviewLayer?) {
        guard let previewLayer = previewLayer else { return }

        let bottomMostSublayer = layer.sublayers?[safe: 0]
        if previewLayer == bottomMostSublayer {
            layer.sublayers?.remove(at: 0)
        }
    }

    // MARK: - Helpers - Factories

    private func makeRectangularMask(innerBounds: CGRect, width: CGFloat = 10) -> CALayer {
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.black.cgColor

        let maskPath = UIBezierPath(rect: innerBounds)
        maskPath.usesEvenOddFillRule = true

        let outerPath = UIBezierPath.init(
            rect: CGRect(
                x: max(0, innerBounds.minX - width),
                y: max(0, innerBounds.minY - width),
                width: innerBounds.width + width * 2,
                height: innerBounds.height + width * 2
            )
        )
        maskPath.append(outerPath)

        maskLayer.path = maskPath.cgPath

        return maskLayer
    }
}

private final class SideButtonsView: FrameBasedView {

    let munimapButton = UIButton(titleText: "munimap")

    let roomsButton = UIButton(titleText: "Rooms")

    private let insets = UIEdgeInsets(all: 5)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.white.withAlphaComponent(0.55)

        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

        addSubviews(munimapButton, roomsButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let currentFrames = frames(forWidth: size.width)
        let bottomMostFrame = currentFrames.max(by: { $0.frame.maxY < $1.frame.maxY })?.frame ?? .zero
        let rightMostFrame = currentFrames.max(by: { $0.frame.maxX < $1.frame.maxX })?.frame ?? .zero
        return CGSize(width: rightMostFrame.maxX + insets.right, height: bottomMostFrame.maxY + insets.bottom)
    }

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {
        frames(forWidth: bounds.width)
    }

    private func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {

        let maxWidth = width - insets.horizontalSum
        let verticalSpacing: CGFloat = 4

        let munimapButtonSize = munimapButton.size(constrainedToWidth: maxWidth)
        let roomsButtonSize = roomsButton.size(constrainedToWidth: maxWidth)
        let contentWidth = max(munimapButtonSize.width, roomsButtonSize.width)

        let munimapButtonFrame = CGRect(
            x: insets.left + (contentWidth - munimapButtonSize.width) / 2,
            y: insets.top,
            size: munimapButtonSize
        )

        let roomsButtonFrame = CGRect(
            x: insets.left + (contentWidth - roomsButtonSize.width) / 2,
            y: munimapButtonFrame.maxY + verticalSpacing,
            size: roomsButtonSize
        )

        return [(munimapButton, munimapButtonFrame), (roomsButton, roomsButtonFrame)]
    }
}
