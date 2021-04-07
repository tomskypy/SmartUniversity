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

    private var bottomOverlayButtonConfiguration: InteractiveOverlayView.ButtonConfiguration? {
        didSet { bottomOverlay.buttonConfiguration = bottomOverlayButtonConfiguration }
    }
    private var bottomOverlayState: InteractiveOverlayView.State? {
        didSet { configureBottomOverlay(for: bottomOverlayState) }
    }
    private var lastOverlayHideAnimationWorkItem: DispatchWorkItem?

    // MARK: - Views

    let blurredOverlayView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let navigateToMunimapSideTapView = SideTapView(side: .right, text: "▻munimap▻")
    private(set) lazy var showRoomsScreenButton = UIButton(titleText: "Rooms", colorProviding: colorProvider)
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

        let bottomOverlayFrameSize = bottomOverlay.size(constrainedToWidth: bounds.width)
        let bottomOverlayFrame = CGRect(
            x: 0,
            y: bounds.height - bottomOverlayFrameSize.height,
            size: bottomOverlayFrameSize
        )

        return frames + [
            (blurredOverlayView, blurredOverlayFrame),
            (navigateToMunimapSideTapView, makeSideViewFrame(for: navigateToMunimapSideTapView, bounds: bounds)),
            (showRoomsScreenButton, makeRoomsButtonFrame(bounds: bounds)),
            (bottomOverlay, bottomOverlayFrame)
        ]
    }

    override func setupSubviews() {
        addSubviews(blurredOverlayView, navigateToMunimapSideTapView, showRoomsScreenButton)
    }

    // MARK: - Reset

    func reset() {
        hideBlurOverlay()
        hideBottomOverlay()

        navigateToMunimapSideTapView.isHidden = false
    }

    // MARK: - munimap tap view

    func hideMunimapSideTapView() {
        navigateToMunimapSideTapView.isHidden = true
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

    private func makeSideViewFrame(for sideView: SideTapView, bounds: CGRect) -> CGRect {
        let sideViewSize = sideView.size(constrainedToWidth: bounds.width / 2)

        let yOffset = (bounds.height - sideViewSize.height) / 2

        let xOffset: CGFloat
        switch sideView {
            case navigateToMunimapSideTapView:  xOffset = bounds.width - sideViewSize.width
            default:                            return .zero
        }

        return CGRect(x: xOffset, y: yOffset, size: sideViewSize)
    }

    private func makeRoomsButtonFrame(bounds: CGRect) -> CGRect {
        let buttonSize = showRoomsScreenButton.sizeThatFits(bounds.size)

        return CGRect(
            x: 0,
            y: (bounds.height - buttonSize.height) / 2,
            size: buttonSize
        )
    }
}
