//
//  ARMapPageScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 13/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

class ARMapPageScreenView: FrameBasedView {

    let navigateBackSideTapView = SideTapView(side: .left, text: "◅back◅")

    private(set) lazy var munimapCornerTapView = CornerTapView( // FIXME: refactor
        configuration: .init(
            corner: .bottomLeft,
            content: .init(
                icon: UIImage(systemName: "map")?.applyingSymbolConfiguration(.init(scale: .medium)),
                text: "munimap",
                textSize: layoutProvider.textSize(.large),
                alignment: .left
            )
        )
    )

    private(set) lazy var arViewCornerTapView = CornerTapView(
        configuration: .init(
            corner: .bottomLeft,
            content: .init(
                icon: UIImage(systemName: "arkit")?.applyingSymbolConfiguration(.init(scale: .medium)),
                text: "AR view",
                textSize: layoutProvider.textSize(.large),
                alignment: .left
            )
        )
    )

    private let colorProvider: ColorProviding
    private let layoutProvider: LayoutProviding

    init(colorProvider: ColorProviding, layoutProvider: LayoutProviding) {
        self.colorProvider = colorProvider
        self.layoutProvider = layoutProvider
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) { nil }

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {
        [
            (navigateBackSideTapView, makeSideViewFrame(for: navigateBackSideTapView, bounds: bounds)),
            (munimapCornerTapView, makeTapViewFrame(for: munimapCornerTapView, bounds: bounds)),
            (arViewCornerTapView, makeTapViewFrame(for: arViewCornerTapView, bounds: bounds))
        ]
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        switch hitView {
            case navigateBackSideTapView,
                 munimapCornerTapView,
                 arViewCornerTapView:   return hitView
            default:                    return nil
        }
    }

    func highlightTapView(_ tapView: CornerTapView) { // FIXME: refactor
        let activeColor = colorProvider.primaryColor
        let activeTextColor = colorProvider.buttonTextColor

        let inactiveColor = UIColor.gray
        let inactiveTextColor = UIColor.darkGray

        switch tapView {
            case munimapCornerTapView:
                munimapCornerTapView.highlight(withColor: activeColor, textColor: activeTextColor)
                arViewCornerTapView.highlight(withColor: inactiveColor, textColor: inactiveTextColor)
            case arViewCornerTapView:
                munimapCornerTapView.highlight(withColor: inactiveColor, textColor: inactiveTextColor)
                arViewCornerTapView.highlight(withColor: activeColor, textColor: activeTextColor)
            default:
                return
        }
    }

    private func makeTapViewFrame(for tapView: CornerTapView, bounds: CGRect) -> CGRect {
        let tapViewWidth = min(tapView.preferredWidth, bounds.width / 2)
        let tapViewSize = tapView.size(constrainedToWidth: tapViewWidth)

        let xOffset: CGFloat
        let yOffset: CGFloat
        switch tapView {
            case munimapCornerTapView:
                xOffset = 0
                yOffset = bounds.height - tapViewSize.height
            case arViewCornerTapView:
                xOffset = bounds.width - tapViewSize.width
                yOffset = bounds.height - tapViewSize.height
            default:
                return .zero
        }

        return CGRect(x: xOffset, y: yOffset, size: tapViewSize)
    }

    private func makeSideViewFrame(for sideView: SideTapView, bounds: CGRect) -> CGRect {
        let sideViewSize = sideView.size(constrainedToWidth: bounds.width / 2)

        let yOffset = (bounds.height - sideViewSize.height) / 2

        let xOffset: CGFloat
        switch sideView {
            case navigateBackSideTapView:   xOffset = 0
            default:                        return .zero
        }

        return CGRect(x: xOffset, y: yOffset, size: sideViewSize)
    }
}

extension ARMapPageScreenView: BaseScreenView {

    func setupSubviews() {

        addSubviews(navigateBackSideTapView, munimapCornerTapView, arViewCornerTapView)
    }
}

private extension CornerTapView {

    func highlight(withColor color: UIColor, textColor: UIColor) {
        backgroundColor = color
        tintColor = color

        self.textColor = textColor
    }
}
