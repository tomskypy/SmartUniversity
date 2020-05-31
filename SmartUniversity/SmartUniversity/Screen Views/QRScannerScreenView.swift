//
//  QRScannerScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 07/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerScreenView: FrameBasedView {

    let blurredOverlayView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    var scannerPreviewLayer: AVCaptureVideoPreviewLayer? {
        didSet {
            guard let scannerPreviewLayer = scannerPreviewLayer else { return }

            layer.sublayers?.insert(scannerPreviewLayer, at: 0)
        }
    }

    var bottomTextOverlayState: InfoTextOverlayView.State? {
        didSet {
            guard let state = bottomTextOverlayState else {
                return bottomOverlay.removeFromSuperview()
            }

            bottomOverlay.state = state
            addSubview(bottomOverlay)
        }
    }

    private let colorProvider: ColorProviding

    private lazy var bottomOverlay = InfoTextOverlayView()

    init(colorProvider: ColorProviding) {
        self.colorProvider = colorProvider
        super.init(frame: .zero)
    }

    override init(frame: CGRect) {
        self.colorProvider = AppColorProvider.shared
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) { nil }

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {

        let blurredOverlayFrame = CGRect(origin: .zero, size: bounds.size)

        let bottomOverlayFrameSize = bottomOverlay.size(constrainedToWidth: bounds.width)
        let bottomOverlayFrame = CGRect(
            x: 0,
            y: bounds.height - bottomOverlayFrameSize.height,
            size: bottomOverlayFrameSize
        )

        return [
            (blurredOverlayView, blurredOverlayFrame),
            (bottomOverlay, bottomOverlayFrame)
        ]
    }

    func hideBlurOverlay() {
        blurredOverlayView.isHidden = true
    }

    func showBlurOverlay(maskBounds: CGRect) {
        blurredOverlayView.layer.mask = createRectangularMask(innerBounds: maskBounds)

        if blurredOverlayView.isHidden {
            blurredOverlayView.isHidden = false
        }
    }

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

extension QRScannerScreenView: BaseScreenView {

    func setupSubviews() {
        addSubview(blurredOverlayView)
    }
}
