//
//  TitledScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

class TitledScreenView: FrameBasedView, BaseScreenView {

    var titleText: String? {
        didSet { configure(withTitleText: titleText) }
    }

    private let label = UILabel(
        font: .systemFont(ofSize: 65, weight: .heavy),
        textColor: UIColor.white.withAlphaComponent(0.45),
        textAlignment: .center
    )

    override open func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {
        let insets = safeAreaInsets

        let contentWidth = bounds.width
        let labelHeight = label.height(constrainedToWidth: contentWidth)

        return [
            (label, CGRect(x: insets.left, y: insets.top, width: contentWidth, height: labelHeight))
        ]
    }

    private func configure(withTitleText titleText: String?) {
        guard let titleText = titleText else {
            return label.removeFromSuperview()
        }

        addSubview(label)
        label.text = titleText
    }

    func setupSubviews() { }
}
