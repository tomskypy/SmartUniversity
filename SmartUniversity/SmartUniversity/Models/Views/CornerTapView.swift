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
        let corner: Corner
        let content: Content
    }

    enum Corner {
        case bottomLeft
        case bottomRight
    }

    struct Content {
        let icon: UIImage?

        let text: String
        let textSize: CGFloat
        let alignment: NSTextAlignment
    }

    // MARK: - Property overrides

    override var insets: UIEdgeInsets {
        layoutProvider.contentInsets(
            for: self,
            respectingSafeAreasOn: [configuration.corner.respectedSafeAreaLayoutSide]
        )
    }

    override var insetAgnosticSubviews: [UIView] { [backgroundView] }

    override var backgroundColor: UIColor? {
        get { backgroundConfiguration.color }
        set {
            guard let backgroundColor = newValue else { return }
            backgroundConfiguration = Self.makeBackgroundConfiguration(with: backgroundColor)
        }
    }

    // MARK: - Delegate

    var tapHandler: (() -> Void)?

    // MARK: - Configuration

    var configuration: Configuration {
        didSet { configure(with: configuration) }
    }

    var preferredWidth: CGFloat {
        let leftMostView = frames(forWidth: .greatestFiniteMagnitude).max(by: { $0.frame.maxX < $1.frame.maxX })
        return (leftMostView?.frame ?? .zero).maxX
    }

    // MARK: - View spacing

    private lazy var contentSpacing = layoutProvider.contentSpacing

    // MARK: - Subviews

    private lazy var iconView = UIImageView()

    private lazy var backgroundView = GradientView(configuration: backgroundConfiguration)

    private var label: UILabel

    // MARK: - Background configuration

    private var backgroundConfiguration: GradientView.Configuration {
        didSet { backgroundView.configuration = backgroundConfiguration }
    }

    // MARK: - Dependencies

    private let colorProvider: ColorProviding
    private let layoutProvider: LayoutProviding

    // MARK: - Inits

    init(configuration: Configuration, colorProvider: ColorProviding, layoutProvider: LayoutProviding) {
        self.configuration = configuration

        self.colorProvider = colorProvider
        self.layoutProvider = layoutProvider

        label = Self.makeLabel(with: configuration.content, colorProvider: colorProvider)
        backgroundConfiguration = Self.makeBackgroundConfiguration(with: colorProvider.overlayColor)

        super.init(frame: .zero)

        configure(with: configuration)
        configureTapDelegate(with: #selector(viewTapped))

        addSubviews(backgroundView, label, iconView)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Layouting

    override func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {
        let contentMaxWidth = width - insets.horizontalSum

        let iconSize = CGSize(width: 60, height: 60)
        let labelSize = label.size(constrainedToWidth: contentMaxWidth)

        let contentWidth = max(iconSize.width, labelSize.width)
        let contentHeight = iconSize.height + contentSpacing + labelSize.height

        let iconViewFrame = CGRect(x: insets.left + (contentWidth - iconSize.width) / 2, y: insets.top, size: iconSize)

        let labelFrame = CGRect(
            x: insets.left + (contentWidth - labelSize.width) / 2,
            y: iconViewFrame.maxY + contentSpacing,
            size: labelSize
        )

        let backgroundFrame = CGRect(
            origin: .zero,
            width: contentWidth + insets.horizontalSum,
            height: contentHeight + insets.verticalSum
        )

        return [(iconView, iconViewFrame), (label, labelFrame), (backgroundView, backgroundFrame)]
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

    // MARK: - Helpers - Configuration

    private func configure(with configuration: Configuration) {
        label = Self.makeLabel(with: configuration.content, colorProvider: colorProvider)
        iconView.image = configuration.content.icon
    }

    // MARK: - Helpers - Factories

    private static func makeLabel(with content: Content, colorProvider: ColorProviding) -> UILabel {
        let label = UILabel(
            font: .boldSystemFont(ofSize: content.textSize),
            textColor: colorProvider.textColor,
            numberOfLines: 0
        )
        label.text = content.text
        label.textAlignment = content.alignment
        return label
    }

    private static func makeBackgroundConfiguration(with overlayColor: UIColor) -> GradientView.Configuration {
        .init(color: overlayColor, axis: .vertical(locations: [0.2, 0.9, 1.0], upToDown: false))
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
