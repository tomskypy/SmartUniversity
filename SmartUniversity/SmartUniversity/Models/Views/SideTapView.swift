//
//  SideTapView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 05/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class SideTapView: VerticalFrameBasedView {

    enum Side {
        case left
        case right
    }

    override var insets: UIEdgeInsets {
        .init(all: 8)
    }

    var tapHandler: (() -> Void)?

    var text: String {
        get { label.text ?? "" }
        set { label.text = String(newValue.intersperse("\n")) }
    }

    private lazy var label = UILabel(
        font: .boldSystemFont(ofSize: layoutProvider.textSize(.normal)),
        textColor: colorProvider.textColor,
        textAlignment: .center,
        numberOfLines: 0
    )

    private let colorProvider: ColorProviding
    private let layoutProvider: LayoutProviding

    init(side: Side, text: String, colorProvider: ColorProviding, layoutProvider: LayoutProviding) {
        self.colorProvider = colorProvider
        self.layoutProvider = layoutProvider
        super.init(frame: .zero)

        self.text = text

        configureTapDelegate(with: #selector(viewTapped))

        backgroundColor = colorProvider.backgroundColor.withAlphaComponent(0.55)

        layer.cornerRadius = 16
        layer.maskedCorners = side.maskedCorners

        addSubview(label)
    }

    required init?(coder: NSCoder) { nil }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(
            width: makeLabelFrame(forWidth: size.width).maxX + insets.right,
            height: super.sizeThatFits(size).height
        )
    }

    override func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {
        [(label, makeLabelFrame(forWidth: width))]
    }

    // MARK: - Handling

    @objc private func viewTapped() {
        tapHandler?()
    }

    // MARK: - Delegate configuration

    private func configureTapDelegate(with selector: Selector) {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
    }

    // MARK: - Helpers - Factories

    private func makeLabelFrame(forWidth width: CGFloat) -> CGRect {
        CGRect(x: insets.left, y: insets.top, size: label.size(constrainedToWidth: width - insets.horizontalSum))
    }
}

private extension SideTapView.Side {

    var maskedCorners: CACornerMask {
        switch self {
        case .right:    return .init(arrayLiteral: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        case .left:     return .init(arrayLiteral: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        }
    }
}
