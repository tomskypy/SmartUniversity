//
//  SideTapView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 05/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class SideTapView: VerticalFrameBasedView {

    override var insets: UIEdgeInsets {
        .init(all: 8)
    }

    var tapHandler: (() -> Void)?

    var text: String {
        get { label.text ?? "" }
        set { label.text = String(newValue.intersperse("\n")) }
    }

    private lazy var label = UILabel(
        font: .boldSystemFont(ofSize: 20),
        textColor: colorProvider.textColor,
        textAlignment: .center,
        numberOfLines: 0
    )

    private let colorProvider: ColorProviding

    init(text: String, colorProvider: ColorProviding) {
        self.colorProvider = colorProvider
        super.init(frame: .zero)

        self.text = text

        configureTapDelegate(with: #selector(viewTapped))

        backgroundColor = colorProvider.backgroundColor.withAlphaComponent(0.55)

        layer.cornerRadius = 12
        layer.maskedCorners = .init(arrayLiteral: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])

        addSubview(label)
    }

    required init?(coder: NSCoder) { nil }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(
            width: makeLabelFrame(forWidth: size.width).maxX + insets.right,
            height: super.sizeThatFits(size).height
        )
    }

    override func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {
        [(label, makeLabelFrame(forWidth: width))]
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

    // MARK: - Helpers - Factories

    private func makeLabelFrame(forWidth width: CGFloat) -> CGRect {
        CGRect(x: insets.left, y: insets.top, size: label.size(constrainedToWidth: width - insets.horizontalSum))
    }
}
