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

    let blurredOverlayView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    private let colorProvider: ColorProviding

    private let bottomOverlay = InfoOverlayView()

    private var bottomOverlayState: InfoOverlayView.State? {
        didSet { configureBottomOverlay(for: bottomOverlayState) }
    }

    private var bottomOverlayButtonConfiguration: InfoOverlayView.ButtonConfiguration? {
        didSet {
            bottomOverlay.buttonConfiguration = bottomOverlayButtonConfiguration
        }
    }

    private var lastOverlayHideAnimationWorkItem: DispatchWorkItem?

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

        return frames + [(blurredOverlayView, blurredOverlayFrame), (bottomOverlay, bottomOverlayFrame)]
    }

    override func setupSubviews() {
        addSubview(blurredOverlayView)
    }

    // MARK: - Reset

    func reset() {
        hideBlurOverlay()
        hideBottomOverlay()
    }

    // MARK: - Blur sqaure overlay

    func showBlurOverlay(maskBounds: CGRect) {
        resetBlurOverlayAnimations()

        blurredOverlayView.layer.mask = createRectangularMask(innerBounds: maskBounds)

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
        for state: InfoOverlayView.State,
        buttonConfiguration: InfoOverlayView.ButtonConfiguration? = nil
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

    private func configureBottomOverlay(for state: InfoOverlayView.State?) {
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

    private func createRectangularMask(innerBounds: CGRect, width: CGFloat = 10) -> CALayer {
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
