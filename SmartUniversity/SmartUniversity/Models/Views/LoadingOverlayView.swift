//
//  LoadingOverlayView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 20/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class LoadingOverlayView: FrameBasedView {

    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        return indicator
    }()

    let loadingLabel = UILabel(text: "Loading", font: .boldSystemFont(ofSize: 20), textColor: .white)

    let layoutProvider: LayoutProviding

    init(layoutProvider: LayoutProviding) {
        self.layoutProvider = layoutProvider
        super.init(frame: .zero)

        backgroundColor = UIColor.black.withAlphaComponent(0.85)

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
            y: activityIndicator.frame.maxY + layoutProvider.contentSpacing,
            size: labelSize
        )
    }
}
