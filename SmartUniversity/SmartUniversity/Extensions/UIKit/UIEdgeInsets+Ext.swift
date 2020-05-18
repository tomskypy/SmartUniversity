//
//  UIEdgeInsets+init.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

    var horizontalSum: CGFloat {
        left + right
    }

    var verticalSum: CGFloat {
        top + bottom
    }

    init(all: CGFloat) {
        self.init(top: all, left: all, bottom: all, right: all)
    }

    init(horizontal: CGFloat) {
        self.init(top: 0, left: horizontal, bottom: 0, right: horizontal)
    }

    init(vertical: CGFloat) {
        self.init(top: vertical, left: 0, bottom: vertical, right: 0)
    }

    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}
