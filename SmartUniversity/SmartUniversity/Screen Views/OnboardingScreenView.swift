//
//  OnboardingScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 11/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class OnboardingScreenView: FrameBasedView {

    private let insets = UIEdgeInsets(horizontal: 15, vertical: 30)

    private let colorProvider: ColorProviding

    private lazy var titleLabel = UILabel(
        font: .boldSystemFont(ofSize: 45),
        textColor: colorProvider.textColor,
        numberOfLines: 0
    )
    private lazy var mainTextLabel = UILabel(
        font: .systemFont(ofSize: 22),
        textColor: colorProvider.textColor,
        numberOfLines: 0
    )
    private lazy var skipButton = UIButton(
        style: .transparent,
        titleText: "Skip",
        backgroundColor: colorProvider.backgroundColor
    )
    private lazy var nextButton = UIButton(titleText: "Next", backgroundColor: .lightGray)

    init(colorProvider: ColorProviding) {
        self.colorProvider = colorProvider
        super.init(frame: .zero)
    }

    override init(frame: CGRect) {
        self.colorProvider = AppColorProvider.shared
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

        let titleWidth = contentWidth - skipButtonFrame.width
        let titleLabelFrame = CGRect(
            x: insets.left,
            y: safeAreaInsets.top + insets.top,
            width: titleWidth,
            height: titleLabel.height(constrainedToWidth: titleWidth)
        )
        frames.append((titleLabel, titleLabelFrame))

        let mainTextLabelHeight = mainTextLabel.height(constrainedToWidth: contentWidth)
        let mainTextLabelFrame = CGRect(
            x: insets.left,
            y: max((bounds.height - mainTextLabelHeight) / 2, titleLabelFrame.maxY + contentVerticalSpacing),
            width: contentWidth,
            height: mainTextLabelHeight
        )
        frames.append((mainTextLabel, mainTextLabelFrame))

        let nextButtonSize = CGSize(width: 100, height: 40)
        let nextButtonFrame = CGRect(
            x: bounds.width - insets.right - nextButtonSize.width,
            y: bounds.height - (safeAreaInsets.bottom + insets.bottom + nextButtonSize.height),
            size: nextButtonSize
        )
        frames.append((nextButton, nextButtonFrame))

        return frames
    }

    func configure(withTitleText titleText: String, mainText: String) {
        titleLabel.text = titleText
        mainTextLabel.text = mainText
    }
}

extension OnboardingScreenView: BaseScreenView {

    func setupSubviews() {
        addSubview(titleLabel)
        addSubview(skipButton)
        addSubview(mainTextLabel)
        addSubview(nextButton)
    }
}
