//
//  OnboardingScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 11/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class OnboardingScreenView: FrameBasedView {
    typealias TapHandler = () -> Void

    var titleText: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var bodyText: String? {
        get { bodyLabel.text }
        set { bodyLabel.text = newValue }
    }

    var buttonText: String? {
        get { nextButton.titleLabel?.text }
        set { nextButton.setTitle(newValue, for: .normal) }
    }

    var isSkipHidden: Bool = false {
        didSet {
            if isSkipHidden {
                skipButton.removeFromSuperview()
            } else {
                addSubview(skipButton)
            }
        }
    }

    var didTapNextHandler: TapHandler? {
        willSet { removeButtonTarget(for: #selector(nextTapped), on: nextButton) }
        didSet {
            guard didTapNextHandler != nil else { return }
            addButtonTarget(for: #selector(nextTapped), on: nextButton)
        }
    }

    var didTapSkipHandler: TapHandler? {
        willSet { removeButtonTarget(for: #selector(skipTapped), on: skipButton) }
        didSet {
            guard didTapSkipHandler != nil else { return }
            addButtonTarget(for: #selector(skipTapped), on: skipButton)
        }
    }

    private lazy var insets = layoutProvider.contentInsets(for: self, respectingSafeAreasOn: .all())

    private lazy var titleLabel = UILabel(
        font: .systemFont(ofSize: 70, weight: .black),
        textColor: colorProvider.primaryColor,
        numberOfLines: 0
    )
    private lazy var bodyLabel = UILabel(
        font: .systemFont(ofSize: layoutProvider.textSize(.normal)),
        textColor: colorProvider.textColor,
        numberOfLines: 0
    )
    private lazy var skipButton = UIButton(
        style: .transparent,
        titleText: "Skip",
        colorProviding: colorProvider
    )
    private lazy var nextButton = UIButton(
        style: .solid(colorProvider.secondaryColor),
        titleText: "Next",
        colorProviding: colorProvider
    )

    private let colorProvider: ColorProviding
    private let layoutProvider: LayoutProviding

    init(colorProvider: ColorProviding, layoutProvider: LayoutProviding) {
        self.colorProvider = colorProvider
        self.layoutProvider = layoutProvider
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) { nil }

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {
        var frames: [(UIView, CGRect)] = []

        let contentWidth = bounds.width - insets.horizontalSum
        let contentVerticalSpacing: CGFloat = 10

        let skipButtonSize = skipButton.size(constrainedToWidth: contentWidth)
        let skipButtonFrame = CGRect(
            x: bounds.width - insets.right - skipButtonSize.width,
            y: insets.top,
            size: skipButtonSize
        )
        frames.append((skipButton, skipButtonFrame))

        let titleMaxHeight = bounds.height / 2 - (insets.top + contentVerticalSpacing)

        let titleSize = titleLabel.size(constrainedToWidth: contentWidth - skipButtonFrame.width)
        let titleYOffset = max((titleMaxHeight - titleSize.height) / 2, 0)
        let titleLabelFrame = CGRect(
            x: insets.left,
            y: insets.top + titleYOffset,
            size: titleSize
        )
        frames.append((titleLabel, titleLabelFrame))

        let bodyLabelHeight = bodyLabel.height(constrainedToWidth: contentWidth)
        let bodyLabelFrame = CGRect(
            x: insets.left,
            y: max((bounds.height - contentVerticalSpacing) / 2, titleLabelFrame.maxY + contentVerticalSpacing),
            width: contentWidth,
            height: bodyLabelHeight
        )
        frames.append((bodyLabel, bodyLabelFrame))

        let nextButtonSize = layoutProvider.preferredSize(for: nextButton)
        let nextButtonFrame = CGRect(
            x: bounds.width - insets.right - nextButtonSize.width,
            y: bounds.height - (insets.bottom + nextButtonSize.height),
            size: nextButtonSize
        )
        frames.append((nextButton, nextButtonFrame))

        return frames
    }

    func configure(withTitleText titleText: String, bodyText: String, asFinal: Bool) {
        titleLabel.text = titleText

        bodyLabel.text = bodyText

        backgroundColor = colorProvider.backgroundColor

        buttonText = asFinal ? "Finish" : "Next"
        isSkipHidden = asFinal
    }

    func configureAsFinal() {
    }

    @objc private func nextTapped() {
        didTapNextHandler?()
    }

    @objc private func skipTapped() {
        didTapSkipHandler?()
    }

    private func removeButtonTarget(for selector: Selector, on button: UIButton) {

        button.removeTarget(self, action: selector, for: .touchUpInside)
    }

    private func addButtonTarget(for selector: Selector, on button: UIButton) {

        button.addTarget(self, action: selector, for: .touchUpInside)
    }
}

extension OnboardingScreenView: BaseScreenView {

    func setupSubviews() {
        addSubview(titleLabel)
        addSubview(skipButton)
        addSubview(bodyLabel)
        addSubview(nextButton)
    }
}
