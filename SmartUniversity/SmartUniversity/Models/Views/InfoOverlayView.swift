//
//  InfoTextOverlayView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 01/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class InfoOverlayView: VerticalFrameBasedView {

    enum State {
        case success(text: String)
        case neutral(text: String)
        case fail(text: String)
        case empty
    }

    struct ButtonConfiguration {
        let text: String
        let color: UIColor
    }

    var state: State = .empty {
        didSet {
            overlay.backgroundColor = state.backgroundColor
            textLabel.text = state.labelText

            switch state {
            case .success, .neutral, .fail:
                if subviews.contains(overlay) == false {
                    addSubview(overlay)
                }
                if subviews.contains(textLabel) == false {
                    addSubview(textLabel)
                }
            case .empty:
                overlay.removeFromSuperview()
                textLabel.removeFromSuperview()
            }
        }
    }

    var buttonConfiguration: ButtonConfiguration? {
        didSet {
            guard let buttonConfiguration = buttonConfiguration else {
                return button.removeFromSuperview()
            }

            button.backgroundColor = buttonConfiguration.color
            button.setTitle(buttonConfiguration.text, for: .normal)

            addSubview(button)
        }
    }

    private let colorProvider: ColorProviding
    private let layoutProvider: LayoutProviding

    private lazy var contentInsets = layoutProvider.contentInsets(
        for: self,
        respectingSafeAreasOn: [.left, .bottom, .right]
    )
    private lazy var contentSpacing = layoutProvider.contentSpacing

    private lazy var overlay: UIView = {
        let overlayView = UIView()
        overlayView.backgroundColor = colorProvider.backgroundColor
        overlayView.alpha = 0.65

        return overlayView
    }()

    private lazy var textLabel = UILabel(
        font: .systemFont(ofSize: 18),
        textColor: colorProvider.textColor,
        numberOfLines: 0
    )

    private lazy var button = UIButton(backgroundColor: .darkGray)

    init(colorProvider: ColorProviding, layoutProvider: LayoutProviding) {
        self.colorProvider = colorProvider
        self.layoutProvider = layoutProvider
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) { nil }

    override func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {

        let textSize = textLabel.size(constrainedToWidth: width - insets.horizontalSum)
        let textFrame = CGRect(
            x: contentInsets.left,
            y: contentInsets.top,
            size: textSize
        )

        let buttonSize = layoutProvider.preferredButtonSize
        let buttonFrame = CGRect(
            x: width - (buttonSize.width + contentInsets.right),
            y: textFrame.maxY + contentSpacing,
            size: buttonSize
        )

        let overlayFrame = CGRect(
            origin: .zero,
            width: bounds.width,
            height: buttonSize.height + contentSpacing + textSize.height + contentInsets.verticalSum
        )

        return [
            (textLabel, textFrame),
            (button, buttonFrame),
            (overlay, overlayFrame)
        ]
    }
}

private extension InfoOverlayView.State {

    var labelText: String? {
        switch self {
        case .success(let text), .neutral(let text), .fail(let text):   return text
        case .empty:                                                    return nil
        }
    }

    var backgroundColor: UIColor? {
        switch self {
        case .success:  return .green
        case .neutral:  return .gray
        case .fail:     return .red
        case .empty:    return nil
        }
    }
}