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

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {

        let blurredOverlayFrame = CGRect(origin: .zero, size: bounds.size)

        return [(view: blurredOverlayView, frame: blurredOverlayFrame)]
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
