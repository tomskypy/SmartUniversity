//
//  VerticalFrameBasedView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

class VerticalFrameBasedView: FrameBasedView {

    var insets: UIEdgeInsets { .init(all: 0) }

    var insetAgnosticSubviews: [UIView] { [] }

    override func layoutSubviews() {
        frames(forWidth: bounds.width).forEach({ $0.view.frame = $0.frame })
    }

    /// Returns most fitting size respecting only width of provided CGSize.
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let bottomMostView = frames(forWidth: size.width).max(by: { $0.frame.maxY < $1.frame.maxY }) else {
            return .zero
        }

        var height = bottomMostView.frame.maxY

        let shouldAddInsetsToHeight = insetAgnosticSubviews.contains(bottomMostView.view) == false
        if shouldAddInsetsToHeight {
            height += insets.bottom
        }

        return CGSize(width: size.width, height: height)
    }

    /// Override this function to layout subviews.
    open func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {
        subviews.map({ (view: $0, frame: .zero) })
    }
}
