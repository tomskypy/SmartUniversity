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

    override var insets: UIEdgeInsets {
        layoutProvider.contentInsets(for: self, respectingSafeAreasOn: .all())
    }

    private var hidingWorkItem: DispatchWorkItem?

    private lazy var label = UILabel(
        font: .systemFont(ofSize: layoutProvider.textSize(.small)),
        textColor: colorProvider.textColor
    )

    private let colorProvider: ColorProviding
    private let layoutProvider: LayoutProviding

    init(initiallyHidden: Bool = true, colorProvider: ColorProviding, layoutProvider: LayoutProviding) {
        self.colorProvider = colorProvider
        self.layoutProvider = layoutProvider

        super.init(frame: .zero)

        backgroundColor = colorProvider.primaryDarkColor
        isHidden = initiallyHidden
    }

    required init?(coder: NSCoder) { nil }

    override func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {
        [(label, CGRect(x: insets.left, y: insets.top, width: width, height: label.height(constrainedToWidth: width)))]
    }

    func reveal(forPeriod visibilityPeriod: VisibilityPeriod, text: String? = nil) {
        hidingWorkItem?.cancel()

        if let text = text {
            label.text = text
        }

        isHidden = false
        if let hideDelaySeconds = visibilityPeriod.hideDelaySeconds {
            let workItem = DispatchWorkItem { [weak self] in
                self?.isHidden = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + hideDelaySeconds, execute: workItem)

            hidingWorkItem = workItem
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
