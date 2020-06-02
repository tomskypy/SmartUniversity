//
//  InfoTextOverlayView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 01/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class InfoTextOverlayView: VerticalFrameBasedView {

    enum State {
        case success(text: String)
        case neutral(text: String)
        case fail(text: String)
        case empty
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

    private let textInsets = UIEdgeInsets(horizontal: 15, vertical: 20)

    private let colorProvider: ColorProviding

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

    init(colorProvider: ColorProviding) {
        self.colorProvider = colorProvider
        super.init(frame: .zero)
    }

    override init(frame: CGRect) {
        self.colorProvider = AppColorProvider.shared
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) { nil }

    override func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {
        let textSize = textLabel.size(constrainedToWidth: width - insets.horizontalSum)
        let textFrame = CGRect(
            x: textInsets.left,
            y: bounds.height - (textSize.height + textInsets.bottom),
            size: textSize
        )

        let overlayFrame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width,
            height: textSize.height + textInsets.verticalSum
        )

        return [
            (textLabel, textFrame),
            (overlay, overlayFrame)
        ]
    }
}

private extension InfoTextOverlayView.State {

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
