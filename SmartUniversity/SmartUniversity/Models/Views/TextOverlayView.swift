//
//  TextOverlayView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class TextOverlayView: VerticalFrameBasedView {

    enum VisibilityPeriod {
        case infinite
        case short
        case long
    }

    private static let additionalTopInset: CGFloat = 8

    override var isHidden: Bool {
        get { super.isHidden }
        set {
            let willHide = newValue
            if willHide {
                hidingWorkItem?.cancel()
            }

            super.isHidden = newValue
        }
    }

    override var insets: UIEdgeInsets {
        layoutProvider.contentInsets(for: self, size: .small, respectingSafeAreasOn: [.top])
    }

    private var hidingWorkItem: DispatchWorkItem?

    private lazy var label = UILabel(
        font: .systemFont(ofSize: layoutProvider.textSize(.small)),
        textColor: colorProvider.lightTextColor,
        textAlignment: .center,
        numberOfLines: 0
    )

    private let colorProvider: ColorProviding
    private let layoutProvider: LayoutProviding

    init(initiallyHidden: Bool = true, colorProvider: ColorProviding, layoutProvider: LayoutProviding) {
        self.colorProvider = colorProvider
        self.layoutProvider = layoutProvider

        super.init(frame: .zero)

        backgroundColor = colorProvider.primaryDarkColor.withAlphaComponent(0.65)
        isHidden = initiallyHidden

        addSubview(label)
    }

    required init?(coder: NSCoder) { nil }

    override func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {
        let contentWidth = width - insets.horizontalSum

        let labelFrame = CGRect(
            x: insets.left,
            y: insets.top + Self.additionalTopInset,
            width: contentWidth,
            height: label.height(constrainedToWidth: contentWidth)
        )
        return [(label, labelFrame)]
    }

    func reveal(forPeriod visibilityPeriod: VisibilityPeriod, text: String? = nil) {
        hidingWorkItem?.cancel()

        if let text = text {
            label.text = text
            setNeedsLayout()
        }

        isHidden = false
        if let hideDelaySeconds = visibilityPeriod.hideDelaySeconds {
            let workItem = DispatchWorkItem { [weak self] in
                self?.isHidden = true
            }
            hidingWorkItem = workItem

            DispatchQueue.main.asyncAfter(deadline: .now() + hideDelaySeconds, execute: workItem)
        }
    }
}

private extension TextOverlayView.VisibilityPeriod {

    var hideDelaySeconds: Double? {
        switch self {
            case .infinite: return nil
            case .long:     return 4.5
            case .short:    return 2.5
        }
    }
}
