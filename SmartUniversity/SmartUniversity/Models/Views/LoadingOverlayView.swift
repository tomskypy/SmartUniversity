//
//  LoadingOverlayView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 20/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class LoadingOverlayView: FrameBasedView {

    var loadingLabelText: String {
        get { loadingLabel.text ?? "" }
        set { loadingLabel.text = newValue}
    }

    private lazy var loadingLabel = UILabel(
        text: "loading",
        font: .systemFont(ofSize: layoutProvider.textSize(.small), weight: .semibold),
        textColor: colorProvider.lightTextColor
    )

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        return indicator
    }()

    private let colorProvider: ColorProviding
    private let layoutProvider: LayoutProviding

    convenience init(loadingText: String, colorProvider: ColorProviding, layoutProvider: LayoutProviding) {
        self.init(colorProvider: colorProvider, layoutProvider: layoutProvider)

        loadingLabel.text = loadingText
    }

    init(colorProvider: ColorProviding, layoutProvider: LayoutProviding) {
        self.colorProvider = colorProvider
        self.layoutProvider = layoutProvider
        super.init(frame: .zero)

        backgroundColor = UIColor.black.withAlphaComponent(0.98)

        addSubviews(activityIndicator, loadingLabel)

        activityIndicator.startAnimating()
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()

        let indicatorSize = activityIndicator.sizeThatFits(bounds.size)
        activityIndicator.frame = CGRect(
            x: (bounds.width - indicatorSize.width) / 2,
            y: (bounds.height - indicatorSize.height) / 2,
            size: indicatorSize
        )

        let labelSize = loadingLabel.size(constrainedToWidth: bounds.width)
        loadingLabel.frame = CGRect(
            x: (bounds.width - labelSize.width) / 2,
            y: activityIndicator.frame.maxY + layoutProvider.contentSpacing * 2,
            size: labelSize
        )
    }
}
