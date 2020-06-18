//
//  AppLayoutProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

enum LayoutSide {
    case top
    case left
    case bottom
    case right
}

protocol LayoutProviding {

    var contentSpacing: CGFloat { get }

    func contentInsets(for view: UIView, respectingSafeAreasOn safeAreaSides: Set<LayoutSide>) -> UIEdgeInsets

    func preferredSize(for button: UIButton) -> CGSize
}

extension LayoutProviding {

    // MARK: - Convenience

    func contentInsets(for view: UIView) -> UIEdgeInsets {
        contentInsets(for: view, respectingSafeAreasOn: [])
    }

    // MARK: - Helpers

    func safeAreaInsets(
        for view: UIView,
        respectingSafeAreasOn safeAreaRespectingSides: Set<LayoutSide> = []
    ) -> UIEdgeInsets {
        let actualSafeAreaInsets = rootSuperview(for: view).safeAreaInsets

        var respectedSafeAreaInsets = UIEdgeInsets.zero
        safeAreaRespectingSides.forEach { side in
            let additionalInsets: UIEdgeInsets
            switch side {
            case .top: additionalInsets = .init(top: actualSafeAreaInsets.top)
            case .left: additionalInsets = .init(left: actualSafeAreaInsets.left)
            case .bottom: additionalInsets = .init(bottom: actualSafeAreaInsets.bottom)
            case .right: additionalInsets = .init(right: actualSafeAreaInsets.right)
            }
            respectedSafeAreaInsets = respectedSafeAreaInsets.merged(with: additionalInsets)
        }
        return respectedSafeAreaInsets
    }

    private func rootSuperview(for view: UIView) -> UIView {
        var rootSuperview = view
        while let superview = rootSuperview.superview {
            rootSuperview = superview
        }
        return rootSuperview
    }
}

final class AppLayoutProvider: LayoutProviding {

    static let shared = AppLayoutProvider()

    private static let contentInsets = UIEdgeInsets(all: 10)
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
