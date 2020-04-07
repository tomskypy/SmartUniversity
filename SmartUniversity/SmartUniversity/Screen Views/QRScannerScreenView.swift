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

    lazy var label: UILabel = {
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
}

extension QRScannerScreenView: BaseScreenView {

    func setupSubviews() {
        addSubview(blurredOverlayView)
    }
}
