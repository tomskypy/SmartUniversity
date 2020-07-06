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

    var titleColor: UIColor = makeTransparentTitleColor(from: .white) {
        didSet { label.textColor = Self.makeTransparentTitleColor(from: titleColor) }
    }

    private lazy var label = UILabel(
        font: .systemFont(ofSize: 65, weight: .heavy),
        textColor: titleColor,
        textAlignment: .center,
        adjustsFontSizeToFitWidth: true
    )

    private lazy var insets = layoutProvider.contentInsets(for: self, respectingSafeAreasOn: .all())

    private let layoutProvider: LayoutProviding

    init(layoutProvider: LayoutProviding) {
        self.layoutProvider = layoutProvider
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) { nil }

    override open func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {

        let contentWidth = bounds.width - insets.horizontalSum
        let labelHeight = label.height(constrainedToWidth: contentWidth) // FIXME: does not scale well when limited

        return [(label, CGRect(x: insets.left, y: insets.top, width: contentWidth, height: labelHeight))]
    }

    override func addSubview(_ view: UIView) {
        insertSubview(view, belowSubview: label)
    }

    func setupSubviews() { }

    private func configure(withTitleText titleText: String?) {
        guard let titleText = titleText else {
            return label.removeFromSuperview()
        }

        label.text = titleText
        addSubview(label)
    }

    private static func makeTransparentTitleColor(from color: UIColor) -> UIColor {
        color.withAlphaComponent(0.35)
    }
}
