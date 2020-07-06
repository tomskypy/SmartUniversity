//
//  AppLayoutProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class AppLayoutProvider: LayoutProviding {

    static let shared = AppLayoutProvider()

    private static let contentInsets = UIEdgeInsets(all: 16)
    private static let minimumButtonSize = CGSize(width: 100, height: 40)

    let contentSpacing: CGFloat = 8

    private init() { }

    func contentInsets(
        for view: UIView,
        respectingSafeAreasOn safeAreaRespectingSides: Set<LayoutSide>
    ) -> UIEdgeInsets {
        var insets = Self.contentInsets

        let shouldAddSafeAreaInsets = safeAreaRespectingSides.count > 0
        if shouldAddSafeAreaInsets {

            insets = insets.merged(with: safeAreaInsets(for: view, respectingSafeAreasOn: safeAreaRespectingSides))
        }
        return insets
    }

    func preferredSize(for button: UIButton) -> CGSize {
        let height = Self.minimumButtonSize.height
        let width = max(
            Self.minimumButtonSize.width,
            button.width(constrainedToHeight: height) + contentSpacing * 2
        )
        return .init(width: width, height: height)
    }
}
