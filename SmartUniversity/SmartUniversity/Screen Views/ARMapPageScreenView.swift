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

    private(set) lazy var munimapCornerTapView = makeTapView(iconSystemName: "map", text: "munimap")

    private(set) lazy var arViewCornerTapView = makeTapView(iconSystemName: "arkit", text: "AR view")

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

    func highlightTapView(_ tapView: CornerTapView) {

        switch tapView {
            case munimapCornerTapView:
                highlightTapView(munimapCornerTapView, asActive: true)
                highlightTapView(arViewCornerTapView, asActive: false)
            case arViewCornerTapView:
                highlightTapView(munimapCornerTapView, asActive: false)
                highlightTapView(arViewCornerTapView, asActive: true)
            default:
                return
        }
    }

    private func highlightTapView(_ tapView: CornerTapView, asActive: Bool) {
        if asActive {
            let activeColor = colorProvider.primaryColor
            let activeTextColor = colorProvider.buttonTextColor

            tapView.highlight(withColor: activeColor, textColor: activeTextColor)
        } else {
            let inactiveColor = UIColor.gray
            let inactiveTextColor = UIColor.darkGray

            tapView.highlight(withColor: inactiveColor, textColor: inactiveTextColor)
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

    private func makeTapView(iconSystemName: String, text: String) -> CornerTapView {
        CornerTapView(
            content: .init(
                icon: UIImage(systemName: iconSystemName)?.applyingSymbolConfiguration(.init(scale: .medium)),
                text: text,
                textSize: layoutProvider.textSize(.large),
                alignment: .center
            )
        )
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
