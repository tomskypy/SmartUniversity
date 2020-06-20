//
//  ARMapPageScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 13/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

class ARMapPageScreenView: FrameBasedView {

    let navigateBackSideTapView = CornerTapView(
        configuration: .init(content: .label(text: "◀ Back", textSize: 18, alignment: .left), corner: .topLeft)
    )

    let munimapSideTapView = CornerTapView(
        configuration: .init(content: .label(text: "muni\nmap", textSize: 40, alignment: .left), corner: .bottomLeft)
    )

    let arViewSideTapView = CornerTapView(
        configuration: .init(content: .label(text: "AR\nview", textSize: 40, alignment: .right), corner: .bottomRight)
    )

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {
        [
            (navigateBackSideTapView, makeTapViewFrame(for: navigateBackSideTapView, bounds: bounds)),
            (munimapSideTapView, makeTapViewFrame(for: munimapSideTapView, bounds: bounds)),
            (arViewSideTapView, makeTapViewFrame(for: arViewSideTapView, bounds: bounds))
        ]
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        switch hitView {
        case navigateBackSideTapView,
             munimapSideTapView,
             arViewSideTapView: return hitView
        default:                return nil
        }
    }

    private func makeTapViewFrame(for tapView: CornerTapView, bounds: CGRect) -> CGRect {
        let tapViewWidth = min(tapView.preferredWidth, bounds.width / 2)
        let tapViewSize = tapView.size(constrainedToWidth: tapViewWidth)

        let xOffset: CGFloat
        let yOffset: CGFloat
        switch tapView {
        case navigateBackSideTapView:
            xOffset = 0
            yOffset = 0
        case munimapSideTapView:
            xOffset = 0
            yOffset = bounds.height - tapViewSize.height
        case arViewSideTapView:
            xOffset = bounds.width - tapViewSize.width
            yOffset = bounds.height - tapViewSize.height
        default:                    return .zero
        }

        return CGRect(x: xOffset, y: yOffset, size: tapViewSize)
    }
}

extension ARMapPageScreenView: BaseScreenView {

    func setupSubviews() {

        addSubviews(navigateBackSideTapView, munimapSideTapView, arViewSideTapView)
    }
}
