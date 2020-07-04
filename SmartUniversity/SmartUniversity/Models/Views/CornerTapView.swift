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
        case label(text: String, textSize: CGFloat, alignment: NSTextAlignment)
    }

    enum Corner {
        case bottomLeft
        case bottomRight
    }

    override var insets: UIEdgeInsets {
        layoutProvider.contentInsets(
            for: self,
            respectingSafeAreasOn: [configuration.corner.respectedSafeAreaLayoutSide]
        )
    }

    override var insetAgnosticSubviews: [UIView] { [backgroundView] }

    var tapHandler: (() -> Void)?

    override var backgroundColor: UIColor? {
        get { backgroundConfiguration.color }
        set {
            guard let backgroundColor = newValue else { return }
            backgroundConfiguration = Self.makeBackgroundConfiguration(with: backgroundColor)
        }
    }

    var configuration: Configuration {
        didSet {
            containedView = Self.makeContainedView(for: configuration.content, colorProvider: colorProvider)
        }
    }

    var preferredWidth: CGFloat {
        let leftMostView = frames(forWidth: .greatestFiniteMagnitude).max(by: { $0.frame.maxX < $1.frame.maxX })
        return (leftMostView?.frame ?? .zero).maxX
    }

    private lazy var backgroundView = GradientView(configuration: backgroundConfiguration)

    private var containedView: UIView {
        willSet { containedView.removeFromSuperview() }
        didSet { addSubview(containedView) }
    }

    private var backgroundConfiguration: GradientView.Configuration {
        didSet { backgroundView.configuration = backgroundConfiguration }
    }

    private let colorProvider: ColorProviding
    private let layoutProvider: LayoutProviding

    init(configuration: Configuration, colorProvider: ColorProviding, layoutProvider: LayoutProviding) {
        self.configuration = configuration

        self.colorProvider = colorProvider
        self.layoutProvider = layoutProvider

        containedView = Self.makeContainedView(for: configuration.content, colorProvider: colorProvider)
        backgroundConfiguration = Self.makeBackgroundConfiguration(with: colorProvider.overlayColor)

        super.init(frame: .zero)

        configureTapDelegate(with: #selector(viewTapped))

        addSubviews(backgroundView, containedView)
    }

    required init?(coder: NSCoder) { nil }

    override func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {
        let contentSize = containedView.size(constrainedToWidth: width)

        let containedViewFrame = CGRect(x: insets.left, y: insets.top, size: contentSize)

        let backgroundFrame = CGRect(
            origin: .zero,
            width: contentSize.width + insets.horizontalSum,
            height: contentSize.height + insets.verticalSum
        )

        return [(containedView, containedViewFrame), (backgroundView, backgroundFrame)]
    }

    @objc private func viewTapped() {
        tapHandler?()
    }

    private func configureTapDelegate(with selector: Selector) {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
    }

    private static func makeContainedView(for content: Content, colorProvider: ColorProviding) -> UIView {
        switch content {
        case .label(let text, let textSize, let alignment):
            let label = UILabel(
                font: .boldSystemFont(ofSize: textSize),
                textColor: colorProvider.textColor,
                numberOfLines: 0
            )
            label.text = text
            label.textAlignment = alignment
            return label
        }
    }

    private static func makeBackgroundConfiguration(with overlayColor: UIColor) -> GradientView.Configuration {
        .init(locations: [0.2, 0.9, 1], color: overlayColor, axis: .vertical)
    }
}

private extension CornerTapView.Corner {

    var maskedCorner: CACornerMask {
        switch self {
        case .bottomLeft:   return .layerMaxXMinYCorner
        case .bottomRight:  return .layerMinXMinYCorner
        }
    }

    var respectedSafeAreaLayoutSide: LayoutSide {
        switch self {
        case .bottomLeft, .bottomRight: return .bottom
        }
    }
}
