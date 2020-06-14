//
//  CornerTapView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 14/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class CornerTapView: VerticalFrameBasedView {

    struct Configuration {
        let content: Content
        let corner: Corner
    }

    enum Content {
        case label(text: String, alignment: NSTextAlignment)
    }

    enum Corner {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }

    override var insets: UIEdgeInsets {
        layoutProvider.contentInsets(
            for: self,
            respectingSafeAreasOn: [configuration.corner.respectedSafeAreaLayoutSide]
        )
    }

    var tapHandler: (() -> Void)?

    var configuration: Configuration {
        didSet {
            containedView = Self.makeContainedView(for: configuration.content, colorProvider: colorProvider)
        }
    }

    var preferredWidth: CGFloat {
        (frames(forWidth: .greatestFiniteMagnitude).max(by: { $0.frame.maxX < $1.frame.maxX })?.frame ?? .zero).maxX + insets.left
    }

    private let colorProvider: ColorProviding
    private let layoutProvider: LayoutProviding

    private var containedView: UIView {
        willSet {
            containedView.removeFromSuperview()
        }
        didSet {
            addSubview(containedView)
        }
    }

    init(configuration: Configuration, colorProvider: ColorProviding, layoutProvider: LayoutProviding) {
        self.configuration = configuration
        self.colorProvider = colorProvider
        self.layoutProvider = layoutProvider
        containedView = Self.makeContainedView(for: configuration.content, colorProvider: colorProvider)

        super.init(frame: .zero)

        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))

        backgroundColor = colorProvider.overlayColor

        layer.cornerRadius = 25
        layer.maskedCorners = [configuration.corner.maskedCorner]

        addSubview(containedView)
    }

    required init?(coder: NSCoder) { nil }

    override func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {
        [(containedView, CGRect(x: insets.left, y: insets.top, size: containedView.size(constrainedToWidth: width)))]
    }

    @objc private func viewTapped() {
        tapHandler?()
    }

    private static func makeContainedView(for content: Content, colorProvider: ColorProviding) -> UIView {
        switch content {
        case .label(let text, let alignment):
            let label = UILabel(
                font: .boldSystemFont(ofSize: 40),
                textColor: colorProvider.textColor,
                numberOfLines: 0
            )
            label.text = text
            label.textAlignment = alignment
            return label
        }
    }
}

private extension CornerTapView.Corner {

    var maskedCorner: CACornerMask {
        switch self {
        case .topLeft:      return .layerMaxXMaxYCorner
        case .topRight:     return .layerMinXMaxYCorner
        case .bottomLeft:   return .layerMaxXMinYCorner
        case .bottomRight:  return .layerMinXMinYCorner
        }
    }

    var respectedSafeAreaLayoutSide: LayoutSide {
        switch self {
        case .topLeft, .topRight:       return .top
        case .bottomLeft, .bottomRight: return .bottom
        }
    }
}
