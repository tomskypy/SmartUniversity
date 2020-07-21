//
//  UIEdgeInsets+Merge.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

    func merged(with insets: UIEdgeInsets) -> UIEdgeInsets {
        .init(
            top: self.top + insets.top,
            left: self.left + insets.left,
            bottom: self.bottom + insets.bottom,
            right: self.right + insets.right
        )
    }
}
