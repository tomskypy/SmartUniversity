//
//  FrameBasedScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 11/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

class FrameBasedScreenView: UIView { // FIXME: Unify implementation with FrameBasedView

    open var margins: UIEdgeInsets { UIEdgeInsets(all: 0) }

    override func layoutSubviews() {
        frames(forBounds: bounds).forEach({ $0.view.frame = $0.frame })
    }

    /// Override this function to layout subviews.
    open func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {
        return subviews.map({ (view: $0, frame: .zero) })
    }
}
