//
//  VerticalFrameBasedView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

class VerticalFrameBasedView: FrameBasedView {

    override var insets: UIEdgeInsets { .init(all: 0) }

    override func layoutSubviews() {
        frames(forWidth: bounds.width).forEach({ $0.view.frame = $0.frame })
    }

    /// Returns most fitting size respecting only width of provided CGSize.
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let bottomMostFrame = frames(forWidth: size.width).max(by: { $0.frame.maxY < $1.frame.maxY })?.frame ?? .zero

        return CGSize(width: size.width, height: bottomMostFrame.maxY + insets.bottom)
    }

    /// Override this function to layout subviews.
    open func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {
        subviews.map({ (view: $0, frame: .zero) })
    }
}
