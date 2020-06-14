//
//  ARMapPageScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 13/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

class ARMapPageScreenView: FrameBasedView {

    let munimapSideTapView = CornerTapView(
        configuration: .init(content: .label(text: "muni\nmap", alignment: .left), corner: .bottomLeft)
    )

    let arViewSideTapView = CornerTapView(
        configuration: .init(content: .label(text: "AR\nview", alignment: .right), corner: .bottomRight)
    )

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {
        [
            (munimapSideTapView, makeTapViewFrame(for: munimapSideTapView, bounds: bounds)),
            (arViewSideTapView, makeTapViewFrame(for: arViewSideTapView, bounds: bounds))
        ]
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        switch hitView {
        case munimapSideTapView:    return hitView
        default:                    return nil
        }
    }

    private func makeTapViewFrame(for tapView: CornerTapView, bounds: CGRect) -> CGRect {
        let tapViewWidth = min(tapView.preferredWidth, bounds.width / 3)
        let tapViewSize = tapView.size(constrainedToWidth: tapViewWidth)

        let xOffset: CGFloat
        switch tapView {
        case munimapSideTapView:    xOffset = 0
        case arViewSideTapView:     xOffset = bounds.width - tapViewSize.width
        default:                    return .zero
        }
        return CGRect(
            x: xOffset,
            y: bounds.height - tapViewSize.height,
            size: tapViewSize
        )
    }
}

extension ARMapPageScreenView: BaseScreenView {

    func setupSubviews() {

        addSubviews(munimapSideTapView, arViewSideTapView)
    }
}
