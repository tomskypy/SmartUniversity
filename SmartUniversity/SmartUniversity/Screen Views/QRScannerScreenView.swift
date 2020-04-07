//
//  QRScannerScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 07/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

class QRScannerScreenView: FrameBasedScreenView {

    let blurredOverlayView = UIVisualEffectView(effect: UIBlurEffect(style: .light)) // FIXME: Consider .regular

    private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.text = "blah blah"
        return label
    }()

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {

        let blurredOverlayFrame = CGRect(
            origin: .zero,
            size: bounds.size
        )

        let labelFrame = CGRect(
            x: 40,
            y: 150,
            width: 100,
            height: 20
        )

        return [(view: blurredOverlayView, frame: blurredOverlayFrame), (label, labelFrame)]
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

        let maskPath = UIBezierPath(rect: bounds)
        maskPath.usesEvenOddFillRule = true

        let outerPath = UIBezierPath.init(
            rect: CGRect(
                x: max(0, bounds.minX - width),
                y: max(0, bounds.minY - width),
                width: bounds.width + width * 2,
                height: bounds.height + width * 2
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
