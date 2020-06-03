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

    var preferredButtonSize: CGSize { get }

    var contentSpacing: CGFloat { get }

    func contentInsets(for view: UIView, respectingSafeAreasOn safeAreaSides: Set<LayoutSide>) -> UIEdgeInsets
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

struct AppLayoutProvider: LayoutProviding {

    static let shared = AppLayoutProvider()

    var preferredButtonSize: CGSize {
        CGSize(width: 100, height: 40)
    }

    var contentSpacing: CGFloat {
        8
    }

    private let defaultContentInsets = UIEdgeInsets(all: 10)

    private init() { }

    func contentInsets(
        for view: UIView,
        respectingSafeAreasOn safeAreaRespectingSides: Set<LayoutSide>
    ) -> UIEdgeInsets {
        var insets = defaultContentInsets

        let shouldAddSafeAreaInsets = safeAreaRespectingSides.count > 0
        if shouldAddSafeAreaInsets {

            insets = insets.merged(with: safeAreaInsets(for: view, respectingSafeAreasOn: safeAreaRespectingSides))
        }
        return insets
    }

}
